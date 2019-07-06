#!/usr/bin/env python3

import argparse
import pathlib
import random

import matplotlib.pyplot as plt
from wordcloud import WordCloud, STOPWORDS

stopwords = STOPWORDS.update(["self", 'item', 'refdef', 'http', 'https', 'null'])

# def random_color_func(
#     word, font_size, position, orientation, random_state=None, **kwargs
# ):
#     h = int(360.0 * 143.0 / 255.0)
#     s = int(77.0 * 255.0 / 255.0)
#     l = int(100.0 * float(random.randint(44, 100)) / 255.0)
#     return "hsl({}, {}%, {}%)".format(h, s, l)


def main():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument(
        "--filename", "-f", dest="filename", required=True, help="Markdown/text file"
    )
    parser.add_argument(
        "--save_dir",
        "-s",
        dest="save_location",
        required=True,
        help="Location to save the image.",
    )

    args = vars(parser.parse_args())

    with open(args.get("filename")) as _f:
        contents = [i.strip() for i in _f.readlines()]
        contents = ' '.join(set(' '.join(set(contents)).split()))

    if contents:
        wordcloud = WordCloud(
            width=900,
            height=200,
            stopwords=stopwords,
            background_color ='black',
            collocations=False,
            # https://matplotlib.org/users/colormaps.html
            colormap='hsv',
            random_state=21,
            max_words=300,
            min_font_size=5
        ).generate(contents)
        # wordcloud.recolor(color_func=random_color_func)
        fig = plt.figure(figsize=[6,6], facecolor=None)
        ax = fig.add_subplot(111)
        ax.imshow(wordcloud, interpolation="bilinear")
        ax.axes.get_xaxis().set_visible(False)
        ax.axes.get_yaxis().set_visible(False)
        ax.set_frame_on(False)
        ax.axis("off")
        location = pathlib.Path(args.get("save_location")).absolute()
        plt.savefig(location, dpi=300, transparent=True, bbox_inches='tight', pad_inches=0)

if __name__ == "__main__":
    main()
