#cmd
#docker build -t gphotos-sync:win -f .\win.Dockerfile .
#docker run -it --rm gphotos-sync:win cmd
#docker run --rm -it --name gphotos-sync -v C:\Users\Clément\.gphotos-sync\:C:\Users\ContainerAdministrator\AppData\Local\gphotos-sync\gphotos-sync\:ro -v C:\Users\Clément\Pictures\gphotos-sync:C:\Users\ContainerAdministrator\storage gphotos-sync:win C:\Users\ContainerAdministrator\storage

#links : 
#https://github.com/yorek/docker-python-nanoserver/blob/master/Dockerfile
#https://docs.python.org/3.8/using/windows.html#installing-without-ui
FROM mcr.microsoft.com/windows/servercore:1909 as servercore

ENV PYTHON_VERSION 3.8.2
ENV PYTHON_PIP_VERSION 20.0.2

USER ContainerAdministrator

RUN curl https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%.exe --output python.exe --silent \
&& python.exe /quiet InstallAllUsers=1 TargetDir=C:\Python PrependPath=1 Shortcuts=0 Include_doc=0 Include_pip=0 Include_test=0 \
&& del /Q /F python.exe \
&& setx /M PATH %PATH%;c:\Python\;c:\Python\scripts\;

RUN curl https://github.com/pypa/get-pip/raw/d59197a3c169cef378a22428a3fa99d33e080a5d/get-pip.py -L --output get-pip.py --silent \
&& python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		pip==%PYTHON_PIP_VERSION% \
&& pip install gphotos-sync

# FROM mcr.microsoft.com/windows/nanoserver:1909

# COPY --from=servercore ["Python", "Python"]

RUN fsutil behavior set SymlinkEvaluation R2R:1 R2L:1 L2L:1 L2R:1

#USER ContainerUser

ENV STORAGE C:/Users/ContainerAdministrator/storage

RUN mkdir "%STORAGE%"

VOLUME $STORAGE

# CMD [ "python" ]

ENTRYPOINT [ "gphotos-sync" ]