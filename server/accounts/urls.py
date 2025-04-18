
from django.urls import path
from accounts.views import AuthUserAPIView, LoginAPIView, RegisterAPIView


urlpatterns = [
    path("register/", RegisterAPIView.as_view(), name="register"),
    path("login/", LoginAPIView.as_view(), name="login"),
    path("user/", AuthUserAPIView.as_view(), name="user"),
]
