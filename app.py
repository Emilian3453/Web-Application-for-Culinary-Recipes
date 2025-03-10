from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import hashlib

app = Flask(__name__)

app.config['MYSQL_HOST'] = '127.0.0.1'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Haicada3453!'
app.config['MYSQL_DB'] = 'retetewebsite'


mysql = MySQL(app)
@app.route('/')
def index():  # Funcția pentru ruta principală
    return render_template('index.html')

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/login/login_form', methods=['POST'])
def login_form():
    if request.method == "POST":
        username = request.form['username']
        password = request.form['password']
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT COUNT(*) FROM Utilizatori WHERE Nume_utilizator = %s", (username,))
        result = cursor.fetchall()
        if result[0][0] == 0:
            cursor.close()
            return render_template("login.html")
        else:
            cursor.execute("SELECT Parola FROM Utilizatori WHERE Nume_utilizator = %s", (username,))
            result = cursor.fetchall()
            cursor.close()
            if result[0][0] ==password:
                return redirect(url_for('home'))

            else:
                return render_template("login.html")

@app.route('/home')
def home():
    return render_template('home.html')

@app.route('/Retete')
def retete():
    return render_template('Retete.html')

@app.route('/AddIngredients', methods=['GET', 'POST'])
def add_ingredients():
    if request.method == 'POST':
        ingredient_name = request.form.get('add_ingredient_name')
        if ingredient_name:
            cursor = mysql.connection.cursor()
            cursor.execute("INSERT INTO Ingrediente (Nume_ingredient) VALUES (%s)", (ingredient_name,))
            mysql.connection.commit()
            cursor.close()

    # Fetch all ingredients
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT Id_ingredient, Nume_ingredient FROM Ingrediente")
    date_ingrediente = cursor.fetchall()  # Fetches [(1, 'Salt'), (2, 'Sugar'), ...]
    cursor.close()
    return render_template('AddIngredients.html', ingrediente2=date_ingrediente)


@app.route('/delete/<int:ingredient_id>', methods=['POST'])
def delete_ingredient(ingredient_id):
    cursor = mysql.connection.cursor()

    try:
        cursor.execute("DELETE FROM Retete WHERE ID_reteta IN (SELECT ri.ID_reteta FROM Retete_Ingrediente ri WHERE ri.ID_ingredient = %s)", (ingredient_id,))
        mysql.connection.commit()
        cursor.execute("DELETE FROM Ingrediente WHERE Id_ingredient = %s", (ingredient_id,))
        mysql.connection.commit()
        return redirect(url_for('add_ingredients'))

    except Exception as e:
        mysql.connection.rollback()
        print(f"Error-Delete ingredients: {e}")
        return "Error-Delete ingredients.", 500

    finally:
        cursor.close()

@app.route('/update_ingredient', methods=['POST'])
def update_ingredient():
    if request.method == 'POST':
        ingredient_id=request.form.get('ingredient_id')
        new_ingredient_name=request.form.get('ingredient_name')
        if ingredient_id and new_ingredient_name:
            cursor = mysql.connection.cursor()
            cursor.execute("UPDATE Ingrediente SET Nume_ingredient = %s WHERE Id_ingredient = %s", (new_ingredient_name,ingredient_id))
            mysql.connection.commit()
            cursor.close()
        return redirect(url_for('add_ingredients'))
@app.route('/AddRecipe', methods=['POST', 'GET'])
def add_recipe():
    if request.method == 'POST':
        recipe_name = request.form.get('recipe_name')
        prep_time = request.form.get('prep_time')
        unit_time = request.form.get('unit_time')
        description = request.form.get('recipe_description')
        ingredients = request.form.getlist('ingredients[]')
        quantities = request.form.getlist('quantities[]')
        units = request.form.getlist('units[]')
        cursor = mysql.connection.cursor()
        cursor.execute("INSERT INTO Retete (Nume_reteta, Descriere, Timp_preparare, Unitate_timp) VALUES (%s, %s, %s, %s)",(recipe_name, description, prep_time, unit_time))
        recipe_id = cursor.lastrowid  # Get the ID of the newly inserted recipe

        # Insert ingredients for the recipe
        for i in range(len(ingredients)):
            ingredient_name = ingredients[i]
            quantity = quantities[i]
            unit = units[i]
            cursor.execute("SELECT ID_ingredient FROM Ingrediente WHERE Nume_ingredient = %s", (ingredient_name,))
            result = cursor.fetchone()
            if result:
                ingredient_id = result[0]
                # Insert the ingredient into the Retete_Ingrediente table
                cursor.execute(
                    "INSERT INTO Retete_Ingrediente (ID_reteta, ID_ingredient, Cantitate, Unitate_masura) VALUES (%s, %s, %s, %s)",(recipe_id, ingredient_id, quantity, unit))

        mysql.connection.commit()  # Commit the transaction
        cursor.close()
        return redirect(url_for('add_recipe'))  # Redirect to the AddRecipe page to refresh the recipe list

    else:  # When the GET request is made, fetch all recipes and ingredients for the form
        cursor = mysql.connection.cursor()

        # Fetch all ingredients for the dropdown in the form
        cursor.execute("SELECT Nume_ingredient FROM Ingrediente")
        ingredients = [row[0] for row in cursor.fetchall()]

        # Fetch all recipes from the database, along with their ingredients
        cursor.execute("CALL GetAllRecipes()")
        recipes = cursor.fetchall()

        cursor.close()
        return render_template('AddRecipe.html', ingrediente=ingredients, recipes=recipes)

@app.route('/delete_recipe', methods=['POST'])
def delete_recipe():
    recipe_id = request.form.get('recipe_id')  # Get the recipe ID from the form
    cursor = mysql.connection.cursor()

    try:
        cursor.execute("DELETE FROM Retete_Ingrediente WHERE ID_reteta = %s", (recipe_id,))
        cursor.execute("DELETE FROM Retete WHERE ID_reteta = %s", (recipe_id,))

        mysql.connection.commit()
        return redirect(url_for('add_recipe'))
    except Exception as e:
        mysql.connection.rollback()  # Rollback if something goes wrong
        print(f"Error-Delete recipe: {e}")
        return "Error-Delete recipe", 500
    finally:
        cursor.close()

@app.route('/update_recipe', methods=['POST'])
def update_recipe():
    recipe_id = request.form.get('recipe_id')
    recipe_name = request.form.get('recipe_name')
    prep_time = request.form.get('recipe_time_prep')
    unit_time = request.form.get('unit_time')
    description = request.form.get('recipe_new_description')

    # Fetch updated list of ingredients, quantities, and units
    ingredients = request.form.getlist('modify_ingredients[]')
    quantities = request.form.getlist('modify_quantities[]')
    units = request.form.getlist('modify_units[]')
    cursor = mysql.connection.cursor()

    try:
        # Update the recipe's basic details if provided
        if recipe_name or prep_time or unit_time or description:
            cursor.execute("UPDATE Retete SET Nume_reteta = COALESCE(%s, Nume_reteta),Timp_preparare = COALESCE(%s, Timp_preparare),Unitate_timp = COALESCE(%s, Unitate_timp),Descriere = COALESCE(%s, Descriere) WHERE ID_reteta = %s", (recipe_name, prep_time, unit_time, description, recipe_id))

        cursor.execute("DELETE FROM Retete_Ingrediente WHERE ID_reteta = %s", (recipe_id,))

        # Add the updated ingredients to the recipe
        for ingredient_name, quantity, unit in zip(ingredients, quantities, units):
            if ingredient_name and quantity and unit:
                # Fetch the ingredient ID by its name
                cursor.execute("SELECT ID_ingredient FROM Ingrediente WHERE Nume_ingredient = %s", (ingredient_name,))
                result = cursor.fetchone()
                if result:
                    ingredient_id = result[0]
                    cursor.execute("INSERT INTO Retete_Ingrediente (ID_reteta, ID_ingredient, Cantitate, Unitate_masura) VALUES (%s, %s, %s, %s)", (recipe_id, ingredient_id, quantity, unit))

        mysql.connection.commit()
        return redirect(url_for('add_recipe'))

    except Exception as e:
        mysql.connection.rollback()
        print(f"Error-Update Recipe: {e}")
        return "Error-Update Recipe", 500

    finally:
        cursor.close()

if __name__ == '__main__':
    app.run(debug=True)
