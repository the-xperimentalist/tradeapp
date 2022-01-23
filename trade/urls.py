from django.urls import path
from trade.views import (
    HomePageAPI, ListCreatePortfolioAPI, ListCreateTradeAPI, TradeDetailAPI, TradeSheetUploadAPI)

urlpatterns = [
    path("trade/", ListCreateTradeAPI.as_view(), name="list-create-trade"),
    path("trade/<int:id>/", TradeDetailAPI.as_view(), name="retrieve-update-destroy-trade"),
    path("sheet_upload/", TradeSheetUploadAPI.as_view(), name="upload_trade_sheet"),
    path("home/<int:queryTime>/", HomePageAPI.as_view(), name="home_page"),
    path("portfolio/", ListCreatePortfolioAPI.as_view(), name="list-create-portfolio")
]
