
TRADE JOURNAL:

To test the module, run:
```
coverage run manage.py test && coverage report && coverage html
```

To do the initial setup for the project server:
```
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
```

To start the server:
```
python manage.py runserver
```

To start the app, go to `mobile` and run: `flutter run`
