from .base import *
import dj_database_url
import os

DEBUG = True

# Development-specific settings
CORS_ALLOW_ALL_ORIGINS = True

# Email backend for development
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Database: Use DATABASE_URL if set (PostgreSQL), otherwise fallback to SQLite
DATABASE_URL = os.getenv('DATABASE_URL')

if DATABASE_URL:
    # PostgreSQL (from Neon or other cloud provider)
    DATABASES = {
        'default': dj_database_url.parse(DATABASE_URL)
    }
    print("✅ Using PostgreSQL from DATABASE_URL")
else:
    # SQLite (local development fallback)
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': BASE_DIR / 'db.sqlite3',
        }
    }
    print("⚠️  Using SQLite (DATABASE_URL not set)")
