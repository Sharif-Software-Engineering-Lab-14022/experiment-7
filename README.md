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

# Copy the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
COPY wait-for-it.sh /app/wait-for-it.sh

# Ensure the entrypoint script is executable
RUN chmod +x /app/entrypoint.sh /app/wait-for-it.sh

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```
 - FROM python:3: مشخص می کند که ایمیج پایه ای از پایتون ۳ استفاده شود.
 - ENV PYTHONUNBUFFERED 1: متغیر محیطی را تنظیم می کند تا خروجی پایتون مستقیما به ترمینال ارسال شود بدون بافرینگ.
 - WORKDIR /app: دایرکتوری کار در داخل کانتینر را به /app تنظیم می کند.
 - COPY requirements.txt .: فایل requirements.txt را از میزبان به دایرکتوری کار کانتینر کپی می کند.
 - RUN pip install --no-cache-dir -r requirements.txt: وابستگی های پایتون را از فایل requirements.txt نصب می کند بدون استفاده از کش برای کاهش اندازه تصویر.
 - COPY . .: دایرکتوری فعلی (فایل های پروژه) را از میزبان به دایرکتوری کار کانتینر کپی می کند.
 - COPY entrypoint.sh | wait-for-it.sh: این دستورات اسکریپت‌های entrypoint.sh و wait-for-it.sh را از host به دایرکتوری /app در ایمیج Docker کپی می‌کنند.
 - RUN chmod: این دستور مجوزهای اجرا برای entrypoint.sh و wait-for-it.sh را تنظیم می‌کند تا اطمینان حاصل شود که آنها می‌توانند در داخل کانتینر اجرا شوند.
 - CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]: مشخص می کند که هنگام شروع کانتینر اجرا شود، سرور جنگو را بر روی 0.0.0.0:8000 شروع می کند.

### فایل docker-compose.yml:
```yaml
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

## ارسال درخواست به وب‌سرور
- ساخت کاربر
<img width="1248" alt="1" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/e43aad35-702d-4974-b0f7-bf4feac31c31">

- وارد شدن کاربر
<img width="1248" alt="1-2" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/0a38e2c7-3ace-4327-9a56-5115965b70ce">

- ساخت یادداشت ۱
<img width="1248" alt="2" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/23f35400-32d5-4688-bbde-2c424921db13">

- ساخت یادداشت ۲
<img width="1248" alt="3" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/1737ac95-4158-45fe-b5ad-f41555440105">

- گرفتن تمام یادداشت‌ها
<img width="1248" alt="4" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/1a0b8431-c1f0-4638-8aa6-a35910048cc5">

- پاک کردن یادداشت ۱
<img width="1248" alt="5" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/ae806b70-90c1-4923-8e05-aef2f228c4c6">

- گرفتن تمام یادداشت‌ها
<img width="1248" alt="6" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/8fb3153c-5f6f-4008-91f8-0691efeead15">

## تعامل با داکر
- مشاهده‌ی imageها و containerها: container اصلی که در آن وب‌سرور در حال اجرا است، مورد اول است. از container دوم برای پایگاه داده در این آزمایش استفاده شده است.
<img width="1088" alt="7) images and containers" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/c2f72389-26fd-46ce-989a-2372db16b642">

- دستور `echo` اجرا شده است.
<img width="1088" alt="8) running docker" src="https://github.com/Sharif-Software-Engineering-Lab-14022/experiment-7/assets/79265203/0485f6cf-b32d-4a82-a474-799ecf3ba787">


## پرسش‌ها
### ۱. وظایف Dockerfile، image و container را توضیح دهید.
وظایف Dockerfile
- دستورالعمل های ساخت یک ایمیج را تعریف می کند
- ایمیج پایه، فایل های کپی شده، متغیرهای محیطی و دستورات اجرایی را مشخص می کند
- فرایند ساخت ایمیج Docker قابل تکرار را خودکار می کند

وظایف image
- قالب read-only حاوی کد برنامه، وابستگی ها و فایل های لازم برای اجرای برنامه
- از دستورالعمل های فایل Dockerfile ساخته می شود
- برای ایجاد کانتینرها استفاده می شود
- در رجیستری Docker برای اشتراک و توزیع ذخیره می شود

وظایف container
- بسته اجرایی سبک وزن و مستقل حاوی کد برنامه و وابستگی ها
- از ایمیج ساخته می شود و در محیط ایزوله شده اجرا می شود
- راهی برای بسته بندی و استقرار برنامه ها به صورت یکپارچه فراهم می کند
- فرایند اصلی مشخص شده در دستور `CMD` یا `ENTRYPOINT` فایل Dockerfile را اجرا می کند

### ۲. از kubernetes برای انجام چه کارهایی می‌توان استفاده کرد؟ رابطه آن با داکر چیست؟

پلتفرم Kubernetes یک پلتفرم متن‌باز برای مدیریت اورکستراسیون containerها است. این پلتفرم توسط گوگل ایجاد و توسعه داده شده و اکنون توسط بنیاد کلود نیتیو کامپیوتینگ (CNCF) نگهداری می‌شود. از Kubernetes برای انجام کارهای زیر می‌توان استفاده کرد:

- **مدیریت و استقرار containerها**: Kubernetes به شما امکان می‌دهد که کانتینرها را به صورت خودکار و بهینه در یک کلاستر از سرورها مستقر و مدیریت کنید.
- **مقیاس‌پذیری خودکار**: Kubernetes می‌تواند تعداد containerهای در حال اجرا را بر اساس بار کاری به صورت خودکار افزایش یا کاهش دهد.
- **تعادل بار (Load Balancing)**: با استفاده از سرویس‌ها و اینگراس (Ingress)، Kubernetes می‌تواند ترافیک را به صورت خودکار بین containerهای مختلف توزیع کند.
- **بازگردانی خودکار (Self-healing)**: در صورتی که یک container یا node از کار بیفتد، Kubernetes به طور خودکار آن را مجدداً راه‌اندازی می‌کند یا جایگزین می‌نماید.
- **مدیریت پیکربندی و اسرار (Secrets)**: Kubernetes ابزارهایی برای مدیریت پیکربندی برنامه‌ها و اطلاعات حساس مانند رمزهای عبور فراهم می‌کند.

#### رابطه Kubernetes با داکر
پلتفرم Docker یک پلتفرم برای ایجاد، ارسال، و اجرای containerها است. چند نکته‌ی کلیدی درباره‌ی رابطه‌ی Kubernetes و Docker به شرح زیر است:

- **استفاده از Docker برای ساخت containerها**: Docker ابزاری است که ایجادکنندگان (developerها) از آن برای بسته‌بندی برنامه‌ها و وابستگی‌های آن‌ها در یک واحد قابل حمل به نام container استفاده می‌کنند.
- **استفاده از Docker در Kubernetes**: در گذشته، Kubernetes از Docker به عنوان یک runtime برای اجرای containerها استفاده می‌کرد. با این حال، از نسخه 1.20 به بعد، Kubernetes از Docker به عنوان runtime پیش‌فرض خود استفاده نمی‌کند و به جای آن از CRI-O یا containerd استفاده می‌کند. این تغییر به دلیل یکپارچگی بهتر با ساختار Kubernetes و نیاز به کاهش وابستگی‌ها صورت گرفته است.
- **همکاری و هماهنگی**: با وجود تغییرات اخیر، هنوز هم بسیاری از ابزارها و پروژه‌های مبتنی بر container از Docker برای ساخت و توسعه استفاده می‌کنند، و سپس Kubernetes برای مدیریت و استقرار آن‌ها به کار می‌رود.

به طور خلاصه، Docker و Kubernetes دو ابزار مکمل هستند که با هم برای ایجاد و مدیریت برنامه‌های مبتنی بر containerها مورد استفاده قرار می‌گیرند، هرچند که Kubernetes وابستگی خود به Docker را کاهش داده است.





