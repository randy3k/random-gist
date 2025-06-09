#! /bin/bash

git clone https://github.com/rstudio/rstudio
cd rstudio

OLDWD=$(pwd)
cd dependencies/common/
bash ./install-dictionaries
bash ./install-mathjax
bash ./install-pandoc

cd "$OLDWD"
mkdir build
cd build
cmake .. -DRSTUDIO_TARGET=Desktop -DCMAKE_BUILD_TYPE=Release -DRSTUDIO_USE_SYSTEM_BOOST=Yes -DBOOST_ROOT=/usr/local/opt/boost-rstudio-server -DBOOST_INCLUDEDIR=/usr/local/opt/boost-rstudio-server/include -DBOOST_LIBRARYDIR=/usr/local/opt/boost-rstudio-server/lib -DCMAKE_CXX_FLAGS="-I/usr/local/opt/openssl/include -I/usr/local/opt/qt/include" -DCMAKE_EXE_LINKER_FLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/opt/boost-rstudio-server/lib -L/usr/local/opt/qt/lib" -DQT_QMAKE_EXECUTABLE="/usr/local/opt/qt/bin/qmake" -DRSTUDIO_CRASHPAD_ENABLED=0
