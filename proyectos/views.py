from django.shortcuts import render

# Create your views here.

from django.http import HttpResponse

def lista_proyectos(request):
    return render(request=request, template_name='proyectos/lista.html')

def proyecto_database(request):
    return render(request=request, template_name='proyectos/base_de_datos.html')

def proyecto_backend(request):
    return render(request=request, template_name='proyectos/backend.html')

def proyecto_frontend(request):
    return render(request=request, template_name='proyectos/frontend.html')