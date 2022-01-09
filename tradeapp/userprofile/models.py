from django.db import models
from django.contrib.auth.models import AbstractBaseUser


class Trader(AbstractBaseUser):
    """
    Overriding the User model
    """
    premium_user = models.BooleanField(default=True)
