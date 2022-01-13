from rest_framework.serializers import ModelSerializer
from trade.models import Trade, TradeSheet


class TradeSerializer(ModelSerializer):

    class Meta:
        model = Trade
        fields = ('__all__')

