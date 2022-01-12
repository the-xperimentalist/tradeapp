from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from phonenumber_field.modelfields import PhoneNumberField


class TraderManager(BaseUserManager):
    """
    The given class contains all the methods required in trader
    """

    def create_user(self, *args, **kwargs):
        """
        The method is overridden to throw error in case of `email`, `name`, `password` not present in the model
        """
        if not "email" in kwargs or not "password" in kwargs or not "name" in kwargs:
            raise ValueError("Missing credentials")
        user = self.model(*args, **kwargs)
        user.set_password(kwargs["password"])
        user.save(using=self._db)
        return user


class Trader(AbstractBaseUser):
    """
    Override abstractuser model to create trader model
    :field premium_user: Whether the user is premium(#TODO: Handle broker partnership condition)
    :field mobile_number: Mobile number details
    """
    email = models.EmailField(max_length=255, unique=True, db_index=True)
    premium_user = models.BooleanField(default=True)
    mobile_number = PhoneNumberField(unique=True, null=True, blank=True)
    name = models.CharField(max_length=255, blank=False, null=False)

    objects = TraderManager()

    USERNAME_FIELD = "email"

    def get_full_name(self):
        return self.name
