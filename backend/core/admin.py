from django.contrib import admin
from django.contrib.auth.models import User
from .models import ContactMessage

# Customice your admin panel

admin.site.site_header = "Panel de Administración AWS Django"
admin.site.index_title = "Gestión del Proyecto"
admin.site.site_title = "Admin AWS Django"

# Register your models here.

admin.site.register(ContactMessage)