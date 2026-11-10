# Assignment 08 · Synthetic Bokeh

Open `Submission_Synthetic_Bokeh.m` in MATLAB and click **Run**. Keep the
`images/` folder beside it. The script displays six figures and saves the
full-resolution outputs and comparisons to `results/`. It uses Image
Processing Toolbox and fixed polygon coordinates, so it runs without
clicks. The starter pair is followed by four public-source examples and
the backpack photo taken in the CSXL at UNC Chapel Hill.

| # | Sharp subject | Disk radius | What to look for |
|---|---|---:|---|
| 1 | Woman in the starter portrait | 15 px | Compare the edge of her cheek against the man’s face in all three methods. |
| 2 | Eileen Collins and her helmet | 19 px | Suit patches and the helmet stay sharp as the flag and shuttle model soften. |
| 3 | Tabby cat | 23 px | The eye and fur detail stand out against blurred branches. |
| 4 | Red hydrant | 26 px | The paint stays crisp. The shadow illustrates the limitation of treating the pavement as a single background. |
| 5 | Sunflower head | 21 px | The main flower separates from the foliage. Look closely at the fine petal tips. |
| 6 | Backpack and straps | 22 px | The logo, zipper, and straps stay sharp while the chair mesh and desk soften. |

`results/Assignment8_Comparison_Overview.png` shows all six examples.
`SOURCES.md` credits the photographs and describes the crop and tonal
adjustment to image 6.

## MATLAB Grader

Paste the full `Submission_Synthetic_Bokeh.m` script, including the functions
at the end. Grader supplies `couple.jpg` and `mask.png` for image 1. The
script is configured to fetch the prepared inputs from GitHub when they
are missing locally. Run the pretest and check all six figures. Review the
AI usage report before submitting and add any work you performed yourself.
