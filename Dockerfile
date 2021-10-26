FROM jupyter/scipy-notebook

# Change to root
USER root

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

 
# Install OpenCV dependencies that are not already there
RUN apt-get update && apt-get install -y \
    cmake \
    libgtk2.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev  

COPY requirements.txt /tmp 
RUN pip install --upgrade pip; \
    pip install --requirement /tmp/requirements.txt

RUN pip install SimpleITK 

RUN pip install itk vtk dicompyler-core pyelastix  pydicom dicom 
 
RUN conda install opencv 

# Back to the default directory
WORKDIR /home/$NB_USER/work

# Switch back to notebook user
USER $NB_USER
CMD ["jupyter", "notebook", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''"]
