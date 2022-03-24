
import pandas as pd
from datetime import datetime
from django_filters.rest_framework import DjangoFilterBackend
from trade.serializers import PortfolioSerializer, TradeSerializer
from trade.models import PortfolioStatus, Trade, TradeSheet, TradeItem
from trade.utils.constants import RangeTime, TradeSheetConstants
from trade.utils.computations import Computations
from rest_framework import filters, status
from rest_framework.response import Response
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView


class ListCreateTradeAPI(ListCreateAPIView):
    """"""
    serializer_class = TradeSerializer
    permission_classes = (IsAuthenticated,)
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    # filterset_fields = ['id', 'trade_symbol', 'related_trade_sheet', 'trade_in', 'trade_out']
    search_fields = ['trade_symbol']
    ordering_fields = ['trade_in', 'trade_out']

    def get_queryset(self):
        return Trade.objects.filter(exec_trader=self.request.user)

    def perform_create(self, serializer):
        return serializer.save(exec_trader=self.request.user)


class TradeDetailAPI(RetrieveUpdateDestroyAPIView):
    """
    """
    serializer_class = TradeSerializer
    permission_classes = (IsAuthenticated,)
    lookup_field="id"

    def get_queryset(self):
        return Trade.objects.filter(exec_trader=self.request.user)

class ListCreatePortfolioAPI(ListCreateAPIView):
    serializer_class = PortfolioSerializer
    permission_classes = (IsAuthenticated,)
    filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
    ordering_fields = ['status_date']

    def get_queryset(self):
        return PortfolioStatus.objects.filter(related_trader=self.request.user)


class HomePageAPI(APIView):
    """
    """
    permission_classes = (IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        """
        The given API shows the details for the home page
        """
        query_time = RangeTime.TIME_MAPPING[int(self.kwargs["queryTime"])]
        trades_to_consider = Trade.objects.filter(
            exec_trader=self.request.user)[:query_time] if query_time != 1000 else Trade.objects.filter(
                exec_trader=self.request.user)
        calculated_ratios = Computations.calculate_win_ratio(
            self.request.user, trades_to_consider)
        return Response({"username": self.request.user.username,
            "wins": calculated_ratios["wins"], "losses": calculated_ratios["losses"],
            "total": calculated_ratios["wins"] + calculated_ratios["losses"],
            "biggestLossAmount": round(float(calculated_ratios["largest_loss"]), 2),
            "biggestLossSymbol": calculated_ratios["largest_loss_symbol"],
            "Profit/Loss": calculated_ratios["pnl"],
            "pnl": calculated_ratios["pnl_type"]})


class TradeSheetUploadAPI(APIView):
    """
    """
    permission_classes = (IsAuthenticated,)

    def post(self, request, *args, **kwargs):
        """
        """
        sheets = request.FILES.getlist("trade_sheets")
        for sheet in sheets:
            df_sheet = pd.read_csv(sheet)
            sheet_instance = TradeSheet(
                uploaded_at=datetime.utcnow(), sheet_name=sheet.name,
                uploaded_by=self.request.user
            )
            sheet_instance.save()
            sheet_instance.raw_file.save(sheet.name, sheet)

            for index, row in df_sheet.iterrows():
                trade_item = TradeItem(symbol=row["symbol"],
                quantity=row["quantity"],
                price=row["price"])
                trade_item.save()

                trade = Trade(trade_item=trade_item,
                time=datetime.strptime(row["order_execution_time"], TradeSheetConstants.ORDER_TIME_FORMAT),
                trade_type=Trade.BUY if row["trade_type"]=="buy" else Trade.SELL,
                exchange=Trade.NSE if row["exchange"] == "NSE" else Trade.BSE,
                related_trade_sheet=sheet_instance,
                exec_trader=self.request.user)
                trade.save()

        trades_to_consider = Trade.objects.filter(related_trade_sheet=sheet_instance)
        portfolio_saved = Computations.calculate_win_ratio(
            self.request.user, trades_to_consider, True)

        return Response(status=status.HTTP_200_OK)
