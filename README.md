# ML-OPS: Machine learning life cycle for the Milling-Directions project

## Specifications

Some specifications on the ML model used in this project and its training process.

### Process of generating the training data (the "meta-images")
-> Checkout the "Blender Addon" project for more info.  

Here are the main steps:
- Import the 3D model (for now only .stl format is supported)
- Apply a normal map texture
- Generate the different views of the textured model with different rotation increments
- Create a 10*10 image grid with the different views of the working piece, this final imgage is the "meta-image" and will be used to train the model.

### Number of images used:
For now the traning set is still rather small: ~100 "meta-images" generated from 10 working pieces and some data augmentation.  
The purpose of this dataset is to validate the project's pipeline, not to train a perfect model.

### Specifics of the ML model
We use an image classifier on a "meta-image" created from different views around a 3D model of a working piece
Several models are available for now:
- efficientnet:
    - input size: 224x224
    - lightweight model
    - SOTA accuracy:
- VGG16:
    - input size: 
    - heavy model:
    - SOTA accuracy:

### Training process
The logging of the hyperparameters used during training is achieved with MLflow
- Data augmentation:
- HyperParameter tuning: 
- Batches/Epochs:

### Performance metrics:
The logging of the model's metrics is also carried out with MLflow. This ensures that the most performant model (not necessarilly the latest) is used for inference.
The following metrics are tracked:
- Accuracy
- Precision ?
- Recall ?
- F1-Score ?

The model's loss is tracked as well.


### Criteria for usability:
    
Accuracy > 90% (or something like that)


## Roadmap:
It would be interesting to compare the performance achieved with the image classification model with another use the face normals as vector embedings to train another classification model


### Technique for image superposition and angle changes ?
