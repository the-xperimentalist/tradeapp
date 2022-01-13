from django.urls import path
from trade.views import ListCreateTradeAPI, TradeDetailAPI

urlpatterns = [
    path("trade/", ListCreateTradeAPI.as_view(), name="list-create-trade"),
    path("trade/<int:id>/", TradeDetailAPI.as_view(), name="retrieve-update-destroy-trade"),
]
