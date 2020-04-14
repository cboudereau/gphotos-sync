#cmd
#docker build -t gphotos-sync:python -f .\python.Dockerfile .
#docker run --rm -it --name gphotos-sync -v C:\Users\Clément\.gphotos-sync\:C:\Users\ContainerAdministrator\AppData\Local\gphotos-sync\gphotos-sync\:ro -v C:\Users\Clément\Pictures\gphotos-sync:C:\storage gphotos-sync:python C:\storage
#TODO : activate windows symlinks
FROM python

RUN pip install gphotos-sync

RUN mkdir C:/storage
VOLUME C:/storage

ENTRYPOINT [ "gphotos-sync" ]