import sys
import subprocess
import tempfile
import os
from PyQt5.QtWidgets import QApplication, QLabel, QWidget, QFileDialog, QPushButton, QVBoxLayout, QLineEdit, QTextEdit, QGridLayout, QHBoxLayout
from PyQt5.QtGui import QColor, QIcon
from PyQt5 import QtWidgets

class MyWindow(QWidget):
    def __init__(self):
        super(MyWindow, self).__init__()
        self.lexerOutput = None
        self.parserOutput = None
        self.lexerOutputLabel = None
        self.parserOutputLabel = None
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
        self.inBrowseButton = QPushButton('Browse file')
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

        # lexer and parser output
        self.lexerOutputLabel = QLabel('Lexer Output:', self)
        self.parserOutputLabel = QLabel('Parser Output:', self)
        self.lexerOutput = QTextEdit()
        self.parserOutput = QTextEdit()
        self.lexerOutput.setTextColor(QColor(0, 0, 0))  # Set text color to black
        self.parserOutput.setTextColor(QColor(0, 0, 0))  # Set text color to black

        outputLayout = QHBoxLayout()
        outputLayout.addWidget(self.lexerOutputLabel)
        outputLayout.addWidget(self.parserOutputLabel)
        self.layout.addLayout(outputLayout)

        outputLayout = QHBoxLayout()
        outputLayout.addWidget(self.lexerOutput)
        outputLayout.addWidget(self.parserOutput)
        self.layout.addLayout(outputLayout)

        self.setLayout(self.layout)

    def browse_file(self):
        qfd = QFileDialog()
        path = "/"
        filter_ = "All files (*)"
        self.file = QFileDialog.getOpenFileName(qfd, "", path, filter_)[0]
        self.inFileBox.setText(self.file)
        self.saveButton.setEnabled(False)

        if self.file:
            with open(self.file, 'r') as file:
                code = file.read()
                self.sourceCodeInput.setPlainText(code)

    def run(self):
        self.lexerOutput.setPlainText("")
        self.parserOutput.setPlainText("")
        try:
            code = self.sourceCodeInput.toPlainText()

            lexer_output, parser_output = self.process_code(code)
            self.lexerOutput.setPlainText(lexer_output)
            self.parserOutput.setPlainText(parser_output)
        except Exception as e:
            self.lexerOutput.setPlainText(f"Error: {str(e)}")
            self.parserOutput.setPlainText(f"Error: {str(e)}")

    def clear(self):
        self.inFileBox.clear()
        self.sourceCodeInput.clear()
        self.lexerOutput.clear()
        self.parserOutput.clear()
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
        print(code)
        try:
            # Paths to the executables
            build_dir = "../cmake-build-debug"
            lexer_executable = os.path.join(build_dir, "LEXER")
            parser_executable = os.path.join(build_dir, "PARSER_GUI_SAMPLE1")

            if not os.path.exists(lexer_executable) or not os.path.exists(parser_executable):
                return "Error: One or both executables not found in the build directories.", ""


            with tempfile.NamedTemporaryFile(delete=False, suffix=".cpp") as temp_file:
                temp_file.write(code.encode())
                temp_file.flush()
                lexer_process = subprocess.Popen([lexer_executable, temp_file.name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                parser_process = subprocess.Popen([parser_executable, temp_file.name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            lexer_stdout, lexer_stderr = lexer_process.communicate()
            parser_stdout, parser_stderr = parser_process.communicate()

            lexer_output = lexer_stdout.decode() + lexer_stderr.decode()
            parser_output = parser_stdout.decode() + parser_stderr.decode()

            return lexer_output, parser_output
        except Exception as e:
            return f"Error: {str(e)}", f"Error: {str(e)}"

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