# experiment-7
It's the seventh experiment of Software Engineering Lab course in Spring 2024 at Sharif University of Technology.

## استقرار پروژه
### فایل Dockerfile:

```dockerfile
FROM python:3

ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```
 - FROM python:3: مشخص می کند که ایمیج پایه ای از پایتون ۳ استفاده شود.
 - ENV PYTHONUNBUFFERED 1: متغیر محیطی را تنظیم می کند تا خروجی پایتون مستقیما به ترمینال ارسال شود بدون بافرینگ.
 - WORKDIR /app: دایرکتوری کار در داخل کانتینر را به /app تنظیم می کند.
 - COPY requirements.txt .: فایل requirements.txt را از میزبان به دایرکتوری کار کانتینر کپی می کند.
 - RUN pip install --no-cache-dir -r requirements.txt: وابستگی های پایتون را از فایل requirements.txt نصب می کند بدون استفاده از کش برای کاهش اندازه تصویر.
 - COPY . .: دایرکتوری فعلی (فایل های پروژه) را از میزبان به دایرکتوری کار کانتینر کپی می کند.
 - CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]: مشخص می کند که هنگام شروع کانتینر اجرا شود، سرور جنگو را بر روی 0.0.0.0:8000 شروع می کند.

### فایل docker-compose.yml:
```yaml
version: '3'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      - DB_NAME=notes_db
      - DB_USER=notes_user
      - DB_PASSWORD=notes_password
      - DB_HOST=db
      - DB_PORT=5432
    depends_on:
      - db

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=notes_db
      - POSTGRES_USER=notes_user
      - POSTGRES_PASSWORD=notes_password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```
- version: '3': نسخه فرمت فایل docker-compose را مشخص می کند.
- services: سرویس هایی را که باید اجرا شوند تعریف می کند.
- web: پیکربندی سرویس وب سرور جنگو.
- build: فایل Dockerfile را برای ساخت ایمیج مشخص می کند.
- ports: پورت ۸۰۰۰ میزبان را به پورت ۸۰۰۰ کانتینر نگاشت می کند.
- environment: متغیرهای محیطی را برای جزئیات اتصال دیتابیس تنظیم می کند.
- depends_on: مشخص می کند که این سرویس به سرویس db وابسته است.
- db: پیکربندی سرویس دیتابیس پستگرس.
- image: نسخه پستگرس را برای استفاده مشخص می کند.
- volumes: یک حجم برای ذخیره سازی دائم دیتابیس را می سازد.
- volumes: یک حجم نامگذاری شده برای ذخیره سازی دیتابیس پستگرس را تعریف می کند.

### فایل settings.py:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('DB_NAME'),
        'USER': os.getenv('DB_USER'),
        'PASSWORD': os.getenv('DB_PASSWORD'),
        'HOST': os.getenv('DB_HOST'),
        'PORT': os.getenv('DB_PORT'),
    }
}
```
- DATABASES: پیکربندی اتصال دیتابیس در جنگو.
- 'default': اتصال دیتابیس پیش فرض را مشخص می کند.
- 'ENGINE': موتور دیتابیس پستگرس را مشخص می کند.
- 'NAME', 'USER', 'PASSWORD', 'HOST', 'PORT': جزئیات اتصال دیتابیس را از متغیرهای محیطی با استفاده از `os.getenv()` دریافت می کند.

### اسکرین‌شات‌ها اسقرار
![build.png](images%2Fbuild.png)
![up.png](images%2Fup.png)


## پرسش‌ها
### ۱. وظایف Dockerfile، image و container را توضیح دهید.
فایل Dockerfile
- دستورالعمل های ساخت یک ایمیج را تعریف می کند
- ایمیج پایه، فایل های کپی شده، متغیرهای محیطی و دستورات اجرایی را مشخص می کند
- فرایند ساخت ایمیج Docker قابل تکرار را خودکار می کند

image
- قالب read-only حاوی کد برنامه، وابستگی ها و فایل های لازم برای اجرای برنامه
- از دستورالعمل های فایل Dockerfile ساخته می شود
- برای ایجاد کانتینرها استفاده می شود
- در رجیستری Docker برای اشتراک و توزیع ذخیره می شود

container
- بسته اجرایی سبک وزن و مستقل حاوی کد برنامه و وابستگی ها
- از ایمیج ساخته می شود و در محیط ایزوله شده اجرا می شود
- راهی برای بسته بندی و استقرار برنامه ها به صورت یکپارچه فراهم می کند
- فرایند اصلی مشخص شده در دستور `CMD` یا `ENTRYPOINT` فایل Dockerfile را اجرا می کند



