from rest_framework import serializers
from rest_framework.serializers import ModelSerializer
from trade.models import Trade, TradeSheet, PortfolioStatus, IndexSymbol, SymbolMark


class TradeSerializer(ModelSerializer):

    class Meta:
        model = Trade
        fields = ('__all__')


class PortfolioSerializer(ModelSerializer):
    symbol = serializers.CharField(source='contained_item.symbol')
    entry_price = serializers.FloatField(source='contained_item.price')
    exit_quantity = serializers.IntegerField(source='contained_item.quantity')

    class Meta:
        model = PortfolioStatus
        fields = ('symbol', 'entry_price', 'exit_quantity', 'exit_price', 'remaining_quantity', 'net_profit', 'status_date', 'id')


class IndexSymbolSerializer(ModelSerializer):

    class Meta:
        model = IndexSymbol
        fields = ('__all__')


class SymbolMarkSerializer(ModelSerializer):

    class Meta:
        model = SymbolMark
        fields = ('__all__')
