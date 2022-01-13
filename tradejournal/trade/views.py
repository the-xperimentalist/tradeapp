
from django_filters.rest_framework import DjangoFilterBackend
from trade.serializers import TradeSerializer
from trade.models import Trade
from rest_framework import filters
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.permissions import IsAuthenticated


class ListCreateTradeAPI(ListCreateAPIView):
    serializer_class = TradeSerializer
    permission_classes = (IsAuthenticated,)
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['id', 'trade_symbol', 'related_trade_sheet', 'trade_in', 'trade_out']
    search_fields = ['trade_symbol']
    ordering_fields = ['trade_in', 'trade_out']

    def get_queryset(self):
        return Trade.objects.filter(exec_trader=self.request.user)

    def perform_create(self, serializer):
        return serializer.save(exec_trader=self.request.user)


class TradeDetailAPI(RetrieveUpdateDestroyAPIView):
    serializer_class = TradeSerializer
    permission_classes = (IsAuthenticated,)
    lookup_field="id"

    def get_queryset(self):
        return Trade.objects.filter(exec_trader=self.request.user)
