from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.contrib.auth.models import User
# from django.shortcuts import render

# Create your views here.

@api_view(['GET'])
def home(request):
    return Response({"message": "Bienvenido a la API de AWS-Django-React"})

@api_view(['POST'])
def contact(request):
    name = request.data.get('name')
    email = request.data.get('email')
    message = request.data.get('message')
    return Response({"message": f"Gracias {name}, tu mensaje ha sido recibido."})

@api_view(['POST'])
def register(request):
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')

    if User.objects.filter(username=username).exists():
        return Response({"error": "El usuario ya existe"}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.create_user(username=username, email=email, password=password)
    return Response({"message": "Usuario creado con éxito"}, status=status.HTTP_201_CREATED)

