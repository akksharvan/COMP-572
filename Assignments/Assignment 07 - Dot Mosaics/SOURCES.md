# Image sources and attribution

Downloaded photographs were converted to RGB PNG and reduced with Lanczos
resampling to approximately 0.85 megapixels. The cat was also cropped to the
upper 1850 rows of the original 1795 x 2397 image. No exposure, color, or
contrast adjustments were applied. Grayscale conversion for images 1-3 and
the dot mosaics are produced by the MATLAB script. Exact download URLs,
dimensions, and crop coordinates are in `images/sources.json`.

| # | Prepared file | Photographer / source | License |
|---|---|---|---|
| 1 | `images/einstein.png` | Orren Jack Turner, 1947. [Albert Einstein Head](https://commons.wikimedia.org/wiki/File:Albert_Einstein_Head.jpg) | Public domain in the United States; source page documents nonrenewal |
| 2 | `images/tabby.png` | Alvesgaspar. [Cat November 2010-1a](https://commons.wikimedia.org/wiki/File:Cat_November_2010-1a.jpg) | [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) |
| 3 | `images/lighthouse.png` | Shellcreek. [West Point Lighthouse, Seattle](https://commons.wikimedia.org/wiki/File:West_Point_Lighthouse._Seattle.jpg) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |
| 4 | `images/sunflower.png` | Don McCulley. [Sunflower Public Domain](https://commons.wikimedia.org/wiki/File:Sunflower_Public_Domain.jpg) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |
| 5 | `images/earth.png` | NASA / Apollo 17 crew. [The Earth seen from Apollo 17](https://commons.wikimedia.org/wiki/File:The_Earth_seen_from_Apollo_17.jpg) | Public domain, NASA |
| 6 | `images/personal_toy.png` | Akksharvan Senthilkumar, personal photograph `IMG_1711.HEIC`: Tree Rex in a miniature vegetable landscape | Student's own camera photograph |

The prepared cat image and its transformed versions (`image2_mosaic.png`,
`image2_comparison.png`, and `image2_resolution_sweep.png`) are adaptations of
Alvesgaspar's photograph and are distributed under **CC BY-SA 3.0**. The overview
is a collection containing this attributed adaptation; the cat adaptation
retains its license. Preserve this attribution and license link when sharing.

The personal input is derived from the student's 8064 x 6048 camera photograph
`IMG_1711.HEIC`. Conventional foreground segmentation replaces the tiled wall
with a smooth neutral backdrop; a 0.55-degree counterclockwise rotation,
tighter crop, gentle shadow lift, and 2.5% color increase prepare the final
3028 x 1930 RGB PNG. The photographed toy, vegetables, leaves, and countertop
are retained. No generated subject or generative image editing was used.
The original HEIC remains unchanged in Downloads. Reproducible edit settings
and masks are retained locally in `photo_edits/`.

`guidance/user_toy_reference.jpg` comes from the product-image URL supplied by
the user: https://m.media-amazon.com/images/I/61y6+qWRYRL.jpg . It is retained
only as a private composition reference, not an assignment input or a personal
photograph. `guidance/toy_forest_sample.png` was created with the built-in
imagegen tool and is also excluded from the assignment inputs and results.

Implementation reference: [MathWorks fspecial documentation](https://www.mathworks.com/help/images/ref/fspecial.html).
