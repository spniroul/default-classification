<h1>Default-Classification</h1>
<h2>Credit Card Default Classification Sample</h2>

<h3>Dataset</h3>
<p>To run this project, download the dataset from Kaggle:</p>
<p><a href="https://www.kaggle.com/datasets/uciml/default-of-credit-card-clients-dataset" target="_blank">
Default of Credit Card Clients Dataset</a></p>

<h3>Methodology</h3>
<ul>
    <li><strong>Initial Model:</strong> We begin by fitting a logistic regression model with all available features.</li>
    <li><strong>Feature Selection:</strong> Since our primary goal is to predict credit card defaults with high specificity, 
        we use the <em>Akaike Information Criterion (AIC)</em> for feature selection.</li>
    <li><strong>Cutoff Selection:</strong> The <em>Receiver Operating Characteristic (ROC) curve</em> is utilized to determine the 
        optimal probability cutoff for classification.</li>
</ul>

<h3>ROC Curve Example</h3>
<p>
    <img src="https://github.com/user-attachments/assets/ecaeb404-33c8-47c7-a0d7-d8ddee3752ff" 
         alt="ROC Curve" width="600">
</p>

<h3>Final Prediction</h3>
<p>At a cutoff threshold of <strong>0.08</strong>, we achieve a <strong>specificity of 0.93</strong>, 
   ensuring a lower false positive rate in predicting credit card defaults.</p>
