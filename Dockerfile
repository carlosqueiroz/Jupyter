FROM jupyter/scipy-notebook

# Change to root
USER root

###################
COPY . /tmp/
RUN apt-get update && \
    cat /tmp/apt.txt | xargs sudo apt-get install -y --no-install-recommends &&\
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN cd $HOME/work; \    
    git clone https://github.com/SuperElastix/SimpleElastix;\
    mkdir build; \ 
    cd build; \
    cmake ../SimpleElastix/SuperBuild; \
    make; \
    cd $HOME/work/build/SimpleITK-build/Wrapping/Python; \
    python Packaging/setup.py install; \
    cd $HOME/work; \
    git clone https://bitbucket.org/e_sabidussi/simpleelastix-workshop.git --depth 1

COPY requirements.txt /tmp 
RUN pip install --upgrade pip; \
    pip install --requirement /tmp/requirements.txt

##########
RUN pip install -U setuptools pip

RUN pip install itk-elastix
RUN apt-get update && apt-get install  -y plastimatch  vtk-dicom-tools



RUN pip install itk vtk dicompyler-core pylinac pyelastix opencv-python  pydicom dicom  cython
 

# Back to the default directory
WORKDIR /home/$NB_USER/work


 

# Switch back to notebook user
USER $NB_USER

CMD ["jupyter", "notebook", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''","--NotebookApp.iopub_data_rate_limit=1e10"]
