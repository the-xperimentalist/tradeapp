from django.urls import path
from trade.views import ListCreateTradeAPI

urlpatterns = [
    path("trade/", ListCreateTradeAPI.as_view(), name="list-create-trade")
]
