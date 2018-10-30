from flask import redirect, url_for, render_template
from flask_login import current_user
from app import app
from ..forms import LoginForm, RegistrationForm
from .auth import *
from .user import *
from .package import *


@app.route('/')
def index():
    if current_user.is_authenticated:
        return redirect(url_for('info'))

    return render_template('index.html',
        l_form=LoginForm(), r_form=RegistrationForm())


# if __name__ == '__main__':
#     app.run(debug=True, use_reloader=True)
