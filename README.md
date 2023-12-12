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
We use an image classifier on the "meta-images" created from different views around a 3D model of a working piece.
The following EfficientNet models are available (only one familly for now, others should be added later):

#### EfficientNet

##### Documentation
- [arxiv paper](https://arxiv.org/abs/1905.11946)
- [EfficientNet in Keras](https://keras.io/api/applications/efficientnet/)
- [Fine Tuning with Keras](https://keras.io/examples/vision/image_classification_efficientnet_fine_tuning/)

##### Input size
|Base model     |Resolution|
|---------------|----------|
|EfficientNetB0 | 224      |
|EfficientNetB1 | 240      |
|EfficientNetB2 | 260      |
|EfficientNetB3 | 300      |
|EfficientNetB4 | 380      |
|EfficientNetB5 | 456      |
|EfficientNetB6 | 528      |
|EfficientNetB7 | 600      |

##### Comments:
- [Transfer learning](https://keras.io/guides/transfer_learning/): only the last XX layers are retrained on our dataset, the rest of the CNN's weights are copied from the training on the imagenet dataset
- lightweight model
- SOTA accuracy:

### Training process
The logging of the hyperparameters used during training is achieved with MLflow
- Data augmentation: switch image positions randomly inside the meta-image (+maybe some additional rotations)
- HyperParameter tuning:
    - base model: pretrained weights from the imagenet dataset (14 million "images in context", 1000 different classes)
    - maxPooling layer
    - top layer is exchanged with a dense layer of 5 neurons
- Batches/Epochs:
    - start with a batch of 16 images
    - Epochs: until the model starts overfiting (early stopping)

### Performance metrics:
The logging of the model's metrics is also carried out with MLflow. This ensures that the most performant model (not necessarilly the latest) is used for inference.
The following metrics are tracked:
- Accuracy
- Precision ?
- Recall ?
- F1-Score ?

The model's loss is tracked as well (used for early stopping)


### Criteria for usability:
    
Accuracy > 90% (or something like that)


## Roadmap:
It would be interesting to compare the performance achieved with the image classification model with another use the face normals as vector embedings to train another classification model


### Technique for image superposition and angle changes ?
