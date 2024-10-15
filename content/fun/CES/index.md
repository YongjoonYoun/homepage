---
title: "CES Function Graphic Calculator"
description: "Explore fun and interactive economics tools."
draft: false
math: true
Date: 2024-10-02
---

The **Constant Elasticity of Substitution (CES) Function** is a fundamental concept in production theory, illustrating how easily one input (like capital) can be substituted for another (like labor) while maintaining the same level of output. This flexibility is crucial for firms as they respond to changes in input costs and technological advancements.

### **CES Production Function Formula**

$$
Y = \left[ \alpha K^{-\rho} + (1 - \alpha) L^{-\rho}\right]^{-\frac{1}{\rho}}
$$

- $ Y $: Total output
- $ K $: Capital input
- $ L $: Labor input
- $  \alpha  $: Distribution parameter (0 <  $\alpha $ < 1)
- $ \rho  $: Substitution parameter related to the elasticity of substitution

### **Parameter Explanations**

1. **Distribution Parameter \( $\alpha$  \)**
   - **Definition**: Determines the weight or share of capital in the production process.
   - **Range**: \( 0 < $\alpha $< 1 \)
   - **Interpretation**:
     - Higher  $\alpha $: Greater emphasis on capital, implying that capital plays a more significant role in production.
     - Lower  $\alpha$: Greater emphasis on labor, suggesting that labor is more crucial.

2. **Substitution Parameter \( $\rho$ \)**
   - **Definition**: Governs the ease with which capital and labor can substitute for each other.
   - **Relationship with Elasticity of Substitution \( $\sigma  $ \):
     $$
     \sigma = \frac{1}{1 + \rho}
     $$
   - **Interpretation**:
     - $ \rho $ = 0: Perfect substitutes (Cobb-Douglas production function).
     - $ \rho$ > 0: Limited substitutability; inputs are less easily replaceable.
     - $ \rho$ < 0: High substitutability; inputs can be easily interchanged.

### **Elasticity of Substitution \( $\sigma$ \)**

$$
\sigma = \frac{1}{1 + \rho}
$$

- $ \sigma > 1$: High substitutability between inputs.
- $ \sigma = 1$: Cobb-Douglas (constant returns to substitution).
- $ \sigma < 1$: Low substitutability between inputs.

### **Practical Examples**

#### **1. Labor Economics: Substituting Capital for Labor**

**Scenario**: A manufacturing firm considers investing in automated machinery to replace some of its manual labor.

- **High Elasticity of Substitution \($\sigma $ > 1\)**:
  - **Implication**: The firm can easily substitute labor with capital.
  - **Outcome**: Increased automation leads to higher productivity with minimal loss in output, as machinery effectively replaces workers.

- **Low Elasticity of Substitution \($\sigma$ < 1\)**:
  - **Implication**: Substituting labor with capital is challenging.
  - **Outcome**: Investments in machinery yield limited productivity gains, and the firm may struggle to reduce labor costs effectively.

#### **2. Health Economics: Substituting Medical Technology for Healthcare Professionals**

**Scenario**: A hospital evaluates the integration of advanced diagnostic equipment to reduce the reliance on specialized medical staff.

- **High Elasticity of Substitution \($\sigma $ > 1\)**:
  - **Implication**: Medical technology can effectively substitute for healthcare professionals.
  - **Outcome**: Improved diagnostic accuracy and efficiency with reduced need for extensive medical staffing.

- **Low Elasticity of Substitution \($\sigma $< 1\)**:
  - **Implication**: Technology cannot easily replace healthcare professionals.
  - **Outcome**: Limited improvements in diagnostic processes, maintaining the necessity for a skilled medical workforce.

---
# CES Function Graphic Calculator

Use the interactive calculator below to explore how changes in capital (K) and labor (L) affect total output (Y) based on the CES production function. Adjust the parameters \($ \alpha $\) and \($\rho$\) to see different substitution scenarios and understand their economic implications.

<div class="visualizer">
  <label for="alpha">&alpha; (0 &lt; &alpha; &lt; 1):
    <span class="tooltip" aria-label="Alpha determines the weight of capital in production. A higher alpha indicates a greater emphasis on automation and technology relative to labor.">
      &#9432;
    </span>
  </label>
  <input type="range" id="alpha" step="0.01" min="0.01" max="0.99" value="0.5" oninput="updateAlphaValue(this.value); updatePlot3DGraph();">
  <span id="alphaValue">0.50</span>

  <label for="rho">&rho; (rho):
    <span class="tooltip" aria-label="Rho determines the elasticity of substitution between capital and labor. Lower rho means higher elasticity, allowing easier substitution between automation and labor.">
      &#9432;
    </span>
  </label>
  <input type="range" id="rho" step="0.01" min="-1" max="1" value="0.5" oninput="updateRhoValue(this.value); updatePlot3DGraph();">
  <span id="rhoValue">0.50</span>

  <label for="K">Capital (K):
    <span class="tooltip" aria-label="Adjust the level of capital input.">
      &#9432;
    </span>
  </label>
  <input type="range" id="K" step="1" min="1" max="50" value="25" oninput="updateKValue(this.value); updatePlot3DGraph();">
  <span id="KValue">25</span>

  <label for="L">Labor (L):
    <span class="tooltip" aria-label="Adjust the level of labor input.">
      &#9432;
    </span>
  </label>
  <input type="range" id="L" step="1" min="1" max="50" value="25" oninput="updateLValue(this.value); updatePlot3DGraph();">
  <span id="LValue">25</span>

  <div class="chart-container">
    <div id="ces3DChart" style="height: 500px;"></div>
  </div>
</div>

<!-- Styling for the Enhanced Visualizer -->
<style>
  .visualizer {
    max-width: 700px;
    margin: 20px auto;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 8px;
    background-color: #ffffff;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  }
  .visualizer label {
    display: block;
    margin-top: 10px;
    font-weight: normal;
    color: #333;
    font-size: 0.95em;
  }
  .visualizer input[type="range"] {
    width: 100%;
    margin-top: 5px;
  }
  .chart-container {
    width: 100%;
    margin-top: 20px;
  }
  .tooltip {
    border-bottom: 1px dotted #333;
    cursor: help;
    margin-left: 5px;
    position: relative;
  }
  .tooltip::after {
    content: attr(aria-label);
    position: absolute;
    left: 50%;
    bottom: 125%;
    transform: translateX(-50%);
    background-color: #333;
    color: #fff;
    padding: 5px;
    border-radius: 3px;
    white-space: nowrap;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.3s;
    z-index: 10;
  }
  .tooltip:hover::after {
    opacity: 1;
  }
</style>

<!-- Include Plotly.js Library for 3D Graphing -->
<script src="https://cdn.plot.ly/plotly-latest.min.js" defer></script>

<!-- Enhanced CES 3D Visualization JavaScript -->
<script>
  (function() {
    let currentPlotData = null;
    let currentLayout = null;

    function updateAlphaValue(val) {
      document.getElementById('alphaValue').innerText = parseFloat(val).toFixed(2);
    }

    function updateRhoValue(val) {
      document.getElementById('rhoValue').innerText = parseFloat(val).toFixed(2);
    }

    function updateKValue(val) {
      document.getElementById('KValue').innerText = val;
    }

    function updateLValue(val) {
      document.getElementById('LValue').innerText = val;
    }

    function plot3DGraph() {
      // Retrieve input values
      const alpha = parseFloat(document.getElementById('alpha').value);
      const rho = parseFloat(document.getElementById('rho').value);
      const KMax = parseInt(document.getElementById('K').value);
      const LMax = parseInt(document.getElementById('L').value);

      // Prepare data for plotting 3D graph of Y vs K and L
      const K = [...Array(KMax).keys()].map(x => x + 1);
      const L = [...Array(LMax).keys()].map(x => x + 1);
      let zValues = [];

      for (let k of K) {
        let zRow = [];
        for (let l of L) {
          let Y;
          if (Math.abs(rho) < 1e-6) {
            // Cobb-Douglas case
            Y = Math.pow(k, alpha) * Math.pow(l, 1 - alpha);
          } else {
            // CES function calculation
            const term1 = alpha * Math.pow(k, -rho);
            const term2 = (1 - alpha) * Math.pow(l, -rho);
            Y = Math.pow(term1 + term2, -1 / rho);
          }
          zRow.push(Y);
        }
        zValues.push(zRow);
      }

      // Plot the 3D graph using Plotly
      currentPlotData = [{
        z: zValues,
        x: K,
        y: L,
        type: 'surface',
        colorscale: 'Viridis'
      }];

      currentLayout = {
        title: 'CES Production Function 3D Visualization',
        scene: {
          xaxis: { title: 'Capital (K)' },
          yaxis: { title: 'Labor (L)' },
          zaxis: { title: 'Output (Y)' },
          camera: {
            eye: { x: 1.5, y: 1.5, z: 1.5, roll: 30, pitch: 30 } // Rotate initial position for a better view
          }
        },
        autosize: true
      };

      Plotly.newPlot('ces3DChart', currentPlotData, currentLayout);
    }

    function updatePlot3DGraph() {
      if (currentPlotData && currentLayout) {
        // Update the plot with the new data
        const alpha = parseFloat(document.getElementById('alpha').value);
        const rho = parseFloat(document.getElementById('rho').value);
        const KMax = parseInt(document.getElementById('K').value);
        const LMax = parseInt(document.getElementById('L').value);

        const K = [...Array(KMax).keys()].map(x => x + 1);
        const L = [...Array(LMax).keys()].map(x => x + 1);
        let zValues = [];

        for (let k of K) {
          let zRow = [];
          for (let l of L) {
            let Y;
            if (Math.abs(rho) < 1e-6) {
              // Cobb-Douglas case
              Y = Math.pow(k, alpha) * Math.pow(l, 1 - alpha);
            } else {
              // CES function calculation
              const term1 = alpha * Math.pow(k, -rho);
              const term2 = (1 - alpha) * Math.pow(l, -rho);
              Y = Math.pow(term1 + term2, -1 / rho);
            }
            zRow.push(Y);
          }
          zValues.push(zRow);
        }

        currentPlotData[0].z = zValues;
        currentPlotData[0].x = K;
        currentPlotData[0].y = L;

        Plotly.react('ces3DChart', currentPlotData, currentLayout);
      }
    }

    // Initial plot when the page loads
    document.addEventListener('DOMContentLoaded', plot3DGraph);

    // Expose the functions to the global scope
    window.plot3DGraph = plot3DGraph;
    window.updateAlphaValue = updateAlphaValue;
    window.updateRhoValue = updateRhoValue;
    window.updateKValue = updateKValue;
    window.updateLValue = updateLValue;
    window.updatePlot3DGraph = updatePlot3DGraph;
  })();
</script>

## **Appendix. Mathematical Derivations**

Understanding the mathematical foundations of the CES function provides deeper insights into how different parameters influence production. Below are the derivations for the Cobb-Douglas case and the behavior of the CES function as \($\rho$\) approaches 0 and $\infty$.

### **1. CES Production Function Overview**

The **Constant Elasticity of Substitution (CES)** production function is given by:

$$
Y = \left[ \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right]^{-\frac{1}{\rho}}
$$

Where:
- $ Y $: Total Output
- $ K $: Capital Input
- $ L $: Labor Input
- $ \alpha $: Distribution Parameter \( 0 < $\alpha$ < 1 \)
- $ \rho $: Substitution Parameter

The **Elasticity of Substitution \($\sigma$ is related to $\rho$ \)** by:

$$
\sigma = \frac{1}{1 + \rho}
$$

### **2. Derivation of the Cobb-Douglas Production Function** \($\rho \rightarrow 0$\) 

The **Cobb-Douglas** production function is a special case of the CES function where the elasticity of substitution \($\sigma$ = 1\), implying \($\rho $ = 0\).

#### **a. Starting with the CES Function:**

$$
Y = \left[ \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right]^{-\frac{1}{\rho}}
$$

#### **b. Taking the Limit as** \($ \rho \rightarrow 0 $\):

Direct substitution leads to an indeterminate form \($0 \times \infty$\). To resolve this, we apply **L'Hopital's Rule**.

1. **Rewriting the CES Function:**

   Let $$ f(\rho) = \left[ \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right]^{-\frac{1}{\rho}}$$ 

2. **Taking Natural Logarithm:**

  $$ 
   \ln Y = -\frac{1}{\rho} \ln \left( \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right)
  $$

3. **Applying L'Hopital's Rule:**

   We evaluate the limit as  $\rho \rightarrow 0 $:

   $$
   \lim_{\rho \to 0} \ln Y  
   $$
   $$
   =\lim_{\rho \to 0} -\frac{1}{\rho} \ln \left( \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right)
   $$

   Recognizing this as  $\frac{0}{0} $ form, we differentiate numerator and denominator with respect to $ \rho$ :

   $$
   \lim_{\rho \to 0} \ln Y 
   $$
   $$
=   \lim_{\rho \to 0} -\frac{d}{d\rho} \ln \left( \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right) / \frac{d}{d\rho} \rho 
   $$
   $$
=   \lim_{\rho \to 0} -\frac{\frac{d}{d\rho} \ln \left( \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right)}{1}
   $$

4. **Differentiating the Numerator:**

   $$
   \frac{d}{d\rho} \ln \left( \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right)  
   $$
   $$
=   \frac{-\alpha K^{-\rho} \ln K - (1 - \alpha) L^{-\rho} \ln L}{\alpha K^{-\rho} + (1 - \alpha) L^{-\rho}}
   $$

5. **Substituting $ \rho$ = 0:**

   As $ \rho \rightarrow 0,  K^{-\rho} \rightarrow 1$  and  $L^{-\rho} \rightarrow 1 $:

   $$
   \lim_{\rho \to 0} \ln Y =
   -\frac{-\alpha \ln K - (1 - \alpha) \ln L}{\alpha + (1 - \alpha)}
   $$
   $$
   = \alpha \ln K + (1 - \alpha) \ln L
   $$

6. **Exponentiating Both Sides:**

   $$
   Y = e^{\alpha \ln K + (1 - \alpha) \ln L} = K^{\alpha} L^{1 - \alpha}
   $$

#### **c. Conclusion:**

As $ \rho \rightarrow 0 $, the CES production function converges to the Cobb-Douglas production function:

$$
Y = K^{\alpha} L^{1 - \alpha}
$$

### **3. Behavior of the CES Function as** $\rho \rightarrow \infty $

Understanding the behavior of the CES function as $\rho$  approaches infinity provides insights into the substitutability between capital and labor.

#### **a. Starting with the CES Function:**

$$
Y = \left[ \alpha K^{-\rho} + (1 - \alpha) L^{-\rho} \right]^{-\frac{1}{\rho}}
$$

#### **b. Analyzing the Limit as $\rho \rightarrow \infty$:**

1. **Understanding the Dominant Term:**

   As $\rho$  becomes very large, $ K^{-\rho}$  and $ L^{-\rho} $ tend towards 0 if $ K > 1 $ and $ L > 1$, or towards infinity if $ K < 1$ and $ L < 1 $. However, assuming $ K, L > 0$, we analyze based on which input is larger.

2. **Comparing  K and L:**

   - **Case 1:** If $ K > L$ , $L^{-\rho} $ becomes negligible compared to $ K^{-\rho} $ as $ \rho \rightarrow \infty$.
   - **Case 2:** If $ L > K$, $K^{-\rho}$ becomes negligible compared to $L^{-\rho}$.
   - **Case 3:** If $ K = L $, both terms are equal.

3. **Simplifying the CES Function:**

   - **Case 1 \($K > L$\):**

     $$
     Y \approx \left[ \alpha K^{-\rho} \right]^{-\frac{1}{\rho}} = \alpha^{-\frac{1}{\rho}} K
     $$

     As $ \rho \rightarrow \infty$, $ \alpha^{-\frac{1}{\rho}} \rightarrow 1$:

     $$
     Y \approx K
     $$

   - **Case 2 \($L > K$\):**

     $$
     Y \approx \left[ (1 - \alpha) L^{-\rho} \right]^{-\frac{1}{\rho}} =
     $$
     $$
     (1 - \alpha)^{-\frac{1}{\rho}} L
     $$

     As $ \rho \rightarrow \infty$, $ (1 - \alpha)^{-\frac{1}{\rho}} \rightarrow 1$:

     $$
     Y \approx L
     $$

   - **Case 3 \($K = L$\):**

     $$
     Y = \left[ \alpha K^{-\rho} + (1 - \alpha) K^{-\rho} \right]^{-\frac{1}{\rho}} = \left[ K^{-\rho} \right]^{-\frac{1}{\rho}} = K
     $$

#### **c. Conclusion:**

As $\rho \rightarrow \infty$, the CES production function approaches a **Leontief (Perfect Complement) Production Function**, where output \(Y\) is determined by the **minimum** of capital \(K\) and labor \(L\):

$$
Y = \min \left( K, L \right)
$$

This implies that inputs are **perfect complements**; increasing one input without increasing the other does not lead to an increase in output.
