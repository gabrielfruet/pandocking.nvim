**pandocking.nvim: be the king of your documents**
=====================================================

**What Pandocking means?**

The term "pandocking" has a dual meaning in the context of pandocking.nvim. On
one hand, "pandocking" can be interpreted as "Pandoc King," implying a mastery
or dominance over the art of using Pandoc.

On the other hand, "pandocking" can be seen as a verb, describing the act of
using Pandoc to transform and manipulate documents. In this sense, "pandocking"
represents the process of converting, formatting, and customizing documents
using Pandoc's capabilities.

**What Pandocking is?**

pandocking.nvim is a neovim plugin that simplifies the process
of working with [Pandoc](https://pandoc.org/). With pandocking, you can
configure viewers, commands, output formats, output paths, and more in a single
window, streamlining your workflow and increasing productivity.

**Features**
------------

* **Simplified Configuration**: Configure pandoc options, viewers, and output paths in a single window.
* **Customizable Commands**: Define custom pandoc commands and save them for future use.
* **Multiple Output Formats**: Easily switch between various output formats, such as PDF, HTML, DOCX, and more.
* **Flexible Output Paths**: Set custom output paths and file names for your generated files.
* **Viewer Integration**: Open generated files in your preferred document viewer(e.g [zathura](https://pwmt.org/projects/zathura/)).

**Getting Started**
-------------------

### Installation

To use pandocking, you'll need to have Pandoc installed on your system. You can
download the latest version from the official [Pandoc
website](https://pandoc.org/installing.html).

### Usage

You can use the next commands for configuring your pandoc
```
:PDKConfig
:PDKHotReload
:PDKStopHotReload
:PDKViewer
```

**Installation**
--------------

### Prerequisites

* Neovim (nvim) version 0.5 or higher
* Pandoc version 2.10 or higher

### Using Lazy.nvim

```lua
    {
        dir="~/dev/lua/pandocking.nvim",
        opts= {
            default_variables= {
                arguments = {
                    output_path = '.pandoc/',
                    input_format = 'markdown',
                    output_format = 'latex',
                    output_extension = 'pdf',
                    render_engine = 'zathura',
                    args = '',
                },
                compile_cmd = 'pandoc {args} -f {input_format} -t {output_format} {input_path} -o {output_path}{output_name}.{output_extension}',
                viewer_cmd = '{render_engine} {output_path}{output_name}.{output_extension}'
            }
        }
    }
```

### Requirements

Make sure you have Pandoc installed on your system and that it's available in your system's PATH. You can check if Pandoc is installed by running the following command:
```bash
pandoc --version
```
If you don't have Pandoc installed, you can download it from the official [Pandoc website](https://pandoc.org/installing.html).

**Screenshots**
--------------

Coming soon!

**Contributing**
--------------

We welcome contributions to pandocking! If you'd like to report an issue or suggest a feature, please open an issue on our [GitHub repository](https://github.com/gabrielfruet/pandocking.nvim).

**License**
----------

pandocking is licensed under the [MIT License](https://opensource.org/licenses/MIT).

**Acknowledgments**
-----------------

We'd like to thank the Pandoc team for creating such an amazing tool. Without Pandoc, pandocking wouldn't be possible.
