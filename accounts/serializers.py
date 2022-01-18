from rest_framework import serializers
from accounts.models import Trader


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        max_length=128, min_length=6, write_only=True
    )

    class Meta:
        model = Trader
        fields = ('username', 'email', 'password')

    def create(self, validated_data):
        return Trader.objects.create_user(**validated_data)


class LoginSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        max_length=128, min_length=6, write_only=True
    )

    class Meta:
        model = Trader
        fields = ('email', 'password', 'token')
        # read_only_fields = ['token']

