
import jwt
from django.conf import settings
from rest_framework.authentication import get_authorization_header, BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed
from accounts.models import Trader


class JWTAuthentication(BaseAuthentication):

    def authenticate(self, request):

        auth_header = get_authorization_header(request)
        auth_data = auth_header.decode('utf-8')
        auth_token = auth_data.split(" ")
        if len(auth_token) != 2:
            raise AuthenticationFailed("Invalid Token")

        token=auth_token[1]
        try:
            payload = jwt.decode(token, settings.SECRET_KEY,algorithms="HS256")

            username = payload["username"]
            user = Trader.objects.get(username=username)

            return (user, token)
        except jwt.ExpiredSignatureError as e:
            raise AuthenticationFailed("Token expired! Login again")
        except jwt.DecodeError as e:
            raise AuthenticationFailed("Token Invalid!")
        except Trader.DoesNotExist:
            raise AuthenticationFailed("No user")
        return super().authenticate(request)
