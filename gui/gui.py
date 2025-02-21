import sys
import subprocess
import tempfile
import os
from PyQt5.QtWidgets import QApplication, QLabel, QWidget, QFileDialog, QPushButton, QVBoxLayout, QLineEdit, QTextEdit, QGridLayout
from PyQt5.QtGui import QColor, QIcon
from PyQt5 import QtWidgets

class MyWindow(QWidget):
    def __init__(self):
        super(MyWindow, self).__init__()
        self.lexerOutput = None
        self.lexerOutputLabel = None
        self.clearButton = None
        self.runButton = None
        self.saveButton = None
        self.sourceCodeInput = None
        self.sourceCodeLabel = None
        self.browseLayout = None
        self.inFileBox = None
        self.inBrowseButton = None
        self.layout = None
        self.file = ""
        self.init_ui()

    def init_ui(self):
        self.setGeometry(700, 700, 800, 800)
        self.setWindowTitle("C/C++ Parser")
        self.layout = QVBoxLayout()

        # input file browse section
        self.inBrowseButton = QPushButton('Browse .cpp file')
        self.inBrowseButton.setStyleSheet("""
            QPushButton{
                background-color: #007acc; /* Blue */
                color: #ffffff;
                border: 1px solid #007acc;
                padding: 5px 5px;
                text-align: center;
                text-decoration: none;
                font-size: 16px;
                border-radius: 3px;
            }
            QPushButton:hover {
                background-color: #005f99; /* Darker Blue */
                color: #ffffff;
            }
        """)
        self.inFileBox = QLineEdit(self.file)
        self.inBrowseButton.clicked.connect(self.browse_file)

        # browse layout
        self.browseLayout = QGridLayout()
        self.browseLayout.addWidget(self.inFileBox, 0, 0)
        self.browseLayout.addWidget(self.inBrowseButton, 0, 1)
        self.layout.addLayout(self.browseLayout)

        # source code input
        self.sourceCodeLabel = QLabel('Source Code:', self)
        self.layout.addWidget(self.sourceCodeLabel)
        self.sourceCodeInput = QTextEdit()
        self.sourceCodeInput.textChanged.connect(self.on_text_changed)
        self.layout.addWidget(self.sourceCodeInput)

        # run button
        self.runButton = QPushButton('')
        self.runButton.setIcon(QIcon("run.png")) #icon
        self.runButton.setStyleSheet("""
            QPushButton{
                background-color: #228B22; /* Forest Green */
                color: #ffffff;
                border: 1px solid #006400;
                padding: 5px 5px;
                text-align: center;
                text-decoration: none;
                font-size: 13px;
                border-radius: 3px;
            }
            QPushButton:hover {
                background-color: #006400; /* Dark Green */
                color: #ffffff;
            }
        """)
        self.layout.addWidget(self.runButton)
        self.runButton.clicked.connect(self.run)

        # clear button
        self.clearButton = QPushButton('Clear')
        self.clearButton.setStyleSheet("""
            QPushButton{
                background-color: #ff0000; /* Red */
                color: #ffffff;
                border: 1px solid #ff0000;
                padding: 5px 5px;
                text-align: center;
                text-decoration: none;
                font-size: 13px;
                border-radius: 3px;
            }
            QPushButton:hover {
                background-color: #cc0000; /* Darker Red */
                color: #ffffff;
            }
        """)
        self.layout.addWidget(self.clearButton)
        self.clearButton.clicked.connect(self.clear)

        # save button
        self.saveButton = QPushButton('Save')
        self.saveButton.setStyleSheet("""
            QPushButton{
                background-color: #ffa500; /* Orange */
                color: #ffffff;
                border: 1px solid #ffa500;
                padding: 5px 5px;
                text-align: center;
                text-decoration: none;
                font-size: 13px;
                border-radius: 3px;
            }
            QPushButton:hover {
                background-color: #cc8400; /* Darker Orange */
                color: #ffffff;
            }
        """)
        self.saveButton.setEnabled(False)
        self.layout.addWidget(self.saveButton)
        self.saveButton.clicked.connect(self.save_file)

        # lexer output
        self.lexerOutputLabel = QLabel('Lexer Output:', self)
        self.layout.addWidget(self.lexerOutputLabel)
        self.lexerOutput = QTextEdit()
        self.lexerOutput.setTextColor(QColor(0, 0, 0))  # Set text color to black
        self.layout.addWidget(self.lexerOutput)

        self.setLayout(self.layout)

    def browse_file(self):
        qfd = QFileDialog()
        path = "/"
        filter_ = "cpp(*.cpp)"
        self.file = QFileDialog.getOpenFileName(qfd, "", path, filter_)[0]
        self.inFileBox.setText(self.file)
        self.saveButton.setEnabled(False)

        if self.file:
            with open(self.file, 'r') as file:
                code = file.read()
                self.sourceCodeInput.setPlainText(code)

    def run(self):
        self.lexerOutput.setPlainText("")
        try:
            if self.file:
                with open(self.file, 'r') as file:
                    code = file.read()
            else:
                code = self.sourceCodeInput.toPlainText()

            lexer_output = self.process_code(code)
            self.lexerOutput.setPlainText(lexer_output)
        except Exception as e:
            self.lexerOutput.setPlainText(f"Error: {str(e)}")

    def clear(self):
        self.inFileBox.clear()
        self.sourceCodeInput.clear()
        self.lexerOutput.clear()
        self.file = ""
        self.saveButton.setEnabled(False)

    def save_file(self):
        options = QFileDialog.Options()
        options |= QFileDialog.DontUseNativeDialog
        file_path, _ = QFileDialog.getSaveFileName(self, "Save File", "", "C++ Files (*.cpp);;All Files (*)", options=options)
        if file_path:
            with open(file_path, 'w') as file:
                file.write(self.sourceCodeInput.toPlainText())

    def on_text_changed(self):
        if not self.file:
            self.saveButton.setEnabled(True)

    def process_code(self, code):
        try:
            # Determine the path to the executable
            build_dir = "../build"  # Recommended build directory
            executable_name = "PARSER_GUI_SAMPLE1"
            executable_path = os.path.join(build_dir, executable_name)

            if not os.path.exists(executable_path):
                # Fallback to the cmake-build-debug directory if the executable is not found
                build_dir = "../cmake-build-debug"
                executable_path = os.path.join(build_dir, executable_name)

            if not os.path.exists(executable_path):
                return "Error: Executable not found in the build directories."

            if self.file:
                # Use the original file if selected
                process = subprocess.Popen([executable_path, self.file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            else:
                # Use a temporary file if no file is selected
                with tempfile.NamedTemporaryFile(delete=False, suffix=".cpp") as temp_file:
                    temp_file.write(code.encode())
                    temp_file.flush()
                    process = subprocess.Popen([executable_path, temp_file.name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            stdout, stderr = process.communicate()
            output = stdout.decode() + stderr.decode()
            return output
        except Exception as e:
            return f"Error: {str(e)}"

f = open("styles.css", "r")
stylesheet = f.read()
f.close()

app = QApplication(sys.argv)
win = MyWindow()
win.setStyleSheet("""
    QWidget {
        background-color: #f0f0f0; /* Light Gray */
        color: #333333; /* Dark Gray */
    }
    QPushButton {
        background-color: #007acc; /* Blue */
        color: #ffffff;
        border: 1px solid #007acc;
        padding: 5px 5px;
        text-align: center;
        text-decoration: none;
        font-size: 13px;
        border-radius: 3px;
    }
    QPushButton:hover {
        background-color: #005f99; /* Darker Blue */
        color: #ffffff;
    }
    QLineEdit, QTextEdit {
        background-color: #ffffff; /* White */
        color: #333333; /* Dark Gray */
        border: 1px solid #cccccc; /* Light Gray */
    }
    QLabel {
        color: #333333; /* Dark Gray */
    }
""")
win.show()
sys.exit(app.exec_())