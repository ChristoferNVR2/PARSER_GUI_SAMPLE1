FROM jozo/pyqt5

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    g++ wget flex build-essential cmake \
    libgl1-mesa-glx libglib2.0-0 \
    libxkbcommon-x11-0 libx11-xcb1 libfontconfig1 libxrender1 \
    libsm6 libice6 libxext6 libxcomposite1 libxi6 libxtst6 libxrandr2 \
    libxfixes3 libxcursor1 libxinerama1 libxcb-shm0 libxcb-shape0 \
    libxcb-xfixes0 libxcb1 libx11-6 libxau6 libxdmcp6 libxdamage1 \
    libxft2 libxcb-xinerama0 \
    libxrandr2 libxinerama1 libxcursor1 \
    libqt5gui5 libqt5widgets5 libqt5core5a \
    qt5-qmake qtbase5-dev \
    x11-apps xvfb \
    && apt-get clean

COPY . /app

RUN wget https://github.com/Kitware/CMake/releases/download/v3.30.0/cmake-3.30.0-linux-x86_64.sh && \
    chmod +x cmake-3.30.0-linux-x86_64.sh && \
    ./cmake-3.30.0-linux-x86_64.sh --skip-license --prefix=/usr/local

RUN mkdir -p build && cd build && \
    cmake .. && \
    make

# Set environment variables for PyQt5 GUI support
ENV QT_QPA_PLATFORM=xcb
ENV DISPLAY=:0
ENV QT_X11_NO_MITSHM=1
ENV XDG_RUNTIME_DIR=/tmp/runtime-root

# Switch to qtuser (which exists in jozo/pyqt5 image)
USER qtuser

RUN mkdir -p /tmp/runtime-root && \
    chmod 0700 /tmp/runtime-root

CMD ["xvfb-run", "--auto-servernum", "sh", "-c", "cd gui && python3 gui.py"]