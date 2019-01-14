library(keras)
library(dplyr)

#### use a VGG16 model without the top layers to generate features
vgg16_notop = keras::application_vgg16(weights = 'imagenet', include_top = FALSE)

#### folder with images
folder = "camera/"
allimages = paste0(folder, dir(folder))

### helper function to extract features for one image into a vector
getImageFeatures = function(imgf){
    img = image_load(
      imgf,
      target_size = c(224,224)
    )
    x = image_to_array(img)
    
    dim(x) <- c(1, dim(x))
    x = imagenet_preprocess_input(x)
    
    # extract features
    features = vgg16_notop %>% predict(x)
    as.numeric(features)
}

#### apply function on all images in the folder and put it into one matrix
#### matrix should have N rows, where N is the number of images
#### and 25088 columns, the dimension of a feature vector
out = purrr::map(allimages, getImageFeatures)
out2 = data.frame(out)
featurematrix = t(as.matrix(out2))
dim(featurematrix)


