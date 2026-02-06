from django.urls import path
from . import views

urlpatterns = [
    path('', views.lista_proyectos, name='lista'),
    path('database', views.proyecto_database, name='base_de_datos'),
    path('backend', views.proyecto_backend, name='backend'),
    path('frontend', views.proyecto_frontend, name='frontend'),
    path('devops', views.proyecto_devops, name='devops'),
    path('fullstack', views.proyecto_fullstack, name='fullstack'),
    path('redes', views.proyecto_redes, name='redes'),
]