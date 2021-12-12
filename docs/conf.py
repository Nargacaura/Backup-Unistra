import sys
import os
import sphinx_rtd_theme

needs_sphinx = '1.3'

project = 'Complots'
copyright = '2020, LAFORET Nicolas, LUDEL Gabriel, MALLET Nicolas, MAMMADOV Ali, KRUPOVICH Olga, LEDDA Damien, LE Remi, KOMMER Jean-Christophe, KRAUTH Mickael'
author = 'LAFORET Nicolas, LUDEL Gabriel, MALLET Nicolas, MAMMADOV Ali, KRUPOVICH Olga, LEDDA Damien, LE Remi, KOMMER Jean-Christophe, KRAUTH Mickael'

file_insertion_enabled = True

sys.path.append(os.path.abspath('extensions'))
extensions = ['sphinx_rtd_theme']
# Set master document to index
master_doc = 'index'

# Set logo
html_logo = 'icon.png'
html_favicon = 'icon.png'

# Retrieve static stylesheets
html_static_path = ['_static']

# html_css_files = [
#     'theme_light.css',
#     'theme_dark.css',
#     'custom.css',
# ]

html_theme = "sphinx_rtd_theme"
html_theme_path = ["_themes", ]

# html_style = 'style.css'

html_context = {
    "display_gitlab": True,  # Integrate Gitlab
    "gitlab_host": "git.unistra.fr",
    "gitlab_user": "nlaforet",  # Username
    "gitlab_repo": "docs",  # Repo name
    "gitlab_version": "master",  # Version
    "conf_py_path": "/docs/",  # Path in the checkout to the docs root
}
