
from trade.serializers import TradeSerializer
from trade.models import Trade
from rest_framework.generics import CreateAPIView, ListAPIView, ListCreateAPIView
from rest_framework.permissions import IsAuthenticated


class ListCreateTradeAPI(ListCreateAPIView):
    serializer_class = TradeSerializer
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        return Trade.objects.filter(exec_trader=self.request.user)

    def perform_create(self, serializer):
        return serializer.save(exec_trader=self.request.user)
