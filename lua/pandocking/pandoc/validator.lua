local M = {}


local pandoc_possible_variables = {
    ['input_format'] = true,
    ['output_format'] = true,
    ['output_extension'] = true,
    ['output_path'] = true,
    ['input_path'] = true,
    ['output_name'] = true,
    ['render_engine'] = true,
    ['args'] = true,
}

local pandoc_possible_values = {
    input_format = {
        ["bibtex"] = true,
        ["biblatex"] = true,
        ["bits"] = true,
        ["commonmark"] = true,
        ["commonmark_x"] = true,
        ["creole"] = true,
        ["csljson"] = true,
        ["csv"] = true,
        ["tsv"] = true,
        ["djot"] = true,
        ["docbook"] = true,
        ["docx"] = true,
        ["dokuwiki"] = true,
        ["endnotexml"] = true,
        ["epub"] = true,
        ["fb2"] = true,
        ["gfm"] = true,
        ["haddock"] = true,
        ["html"] = true,
        ["ipynb"] = true,
        ["jats"] = true,
        ["jira"] = true,
        ["json"] = true,
        ["latex"] = true,
        ["markdown"] = true,
        ["markdown_mmd"] = true,
        ["markdown_phpextra"] = true,
        ["markdown_strict"] = true,
        ["mediawiki"] = true,
        ["man"] = true,
        ["muse"] = true,
        ["native"] = true,
        ["odt"] = true,
        ["opml"] = true,
        ["org"] = true,
        ["ris"] = true,
        ["rtf"] = true,
        ["rst"] = true,
        ["t2t"] = true,
        ["textile"] = true,
        ["tikiwiki"] = true,
        ["twiki"] = true,
        ["typst"] = true,
        ["vimwiki"] = true,
    },
    output_format = {
        ["ansi"] = true,
        ["asciidoc"] = true,
        ["asciidoc_legacy"] = true,
        ["asciidoctor"] = true,
        ["beamer"] = true,
        ["bibtex"] = true,
        ["biblatex"] = true,
        ["chunkedhtml"] = true,
        ["commonmark"] = true,
        ["commonmark_x"] = true,
        ["context"] = true,
        ["csljson"] = true,
        ["djot"] = true,
        ["docbook"] = true,
        ["docbook5"] = true,
        ["docx"] = true,
        ["dokuwiki"] = true,
        ["epub"] = true,
        ["epub2"] = true,
        ["fb2"] = true,
        ["gfm"] = true,
        ["haddock"] = true,
        ["html"] = true,
        ["html4"] = true,
        ["icml"] = true,
        ["ipynb"] = true,
        ["jats_archiving"] = true,
        ["jats_articleauthoring"] = true,
        ["jats_publishing"] = true,
        ["jats"] = true,
        ["jira"] = true,
        ["json"] = true,
        ["latex"] = true,
        ["man"] = true,
        ["markdown"] = true,
        ["markdown_mmd"] = true,
        ["markdown_phpextra"] = true,
        ["markdown_strict"] = true,
        ["markua"] = true,
        ["mediawiki"] = true,
        ["ms"] = true,
        ["muse"] = true,
        ["native"] = true,
        ["odt"] = true,
        ["opml"] = true,
        ["opendocument"] = true,
        ["org"] = true,
        ["pdf"] = true,
        ["plain"] = true,
        ["pptx"] = true,
        ["rst"] = true,
        ["rtf"] = true,
        ["texinfo"] = true,
        ["textile"] = true,
        ["slideous"] = true,
        ["slidy"] = true,
        ["dzslides"] = true,
        ["revealjs"] = true,
        ["s5"] = true,
        ["tei"] = true,
        ["typst"] = true,
        ["xwiki"] = true,
        ["zimwiki"] = true,
    },
    render_engine = {
        ["zathura"] = true
    }
}

---@param tbl table<string, string>
---@return boolean, table<string, string | table>
function M.verify(tbl)
    local values = {}
    local inconsistent_keys = {}
    local ok = true

    for k,v in pairs(tbl) do
        if not pandoc_possible_variables[k] then
            table.insert(inconsistent_keys, k)
            ok = false
        end

        if not pandoc_possible_values[k] then
            goto continue
        end

        if not pandoc_possible_values[k][v] then
            ok = false
            values[k] = v
        end
        ::continue::
    end

    if #inconsistent_keys > 0 then
        values.inconsistent_keys = inconsistent_keys
    end

    return ok, values
end

return M
