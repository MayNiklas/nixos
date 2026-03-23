{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.mayniklas.programs.python;
in
{

  options.mayniklas.programs.python.enable = mkEnableOption "enable python3 with libs";

  config = mkIf cfg.enable {
    home.packages =
      let
        my-python-packages =
          python-packages: with python-packages; [
            requestsaiohttp
            beautifulsoup4
            black
            dateparser
            flake8
            fpdf2
            httpx
            jsonschema
            lxml
            matplotlib
            nltk
            numpy
            ollama
            openai
            opencv-python
            openpyxl
            pandas
            pillow
            pip
            plotly
            psutil
            pydantic
            pypdf2
            pytest
            python-dateutil
            python-dotenv
            pyyaml
            reportlab
            requests
            scikit-learn
            seaborn
            setuptools
            # spacy
            # tensorflow
            # textblob
            toml
            torch
            transformers
            weasyprint
          ];
        python-with-packages = pkgs.python3.withPackages my-python-packages;
      in
      with pkgs;
      [ python-with-packages ];
  };

}
