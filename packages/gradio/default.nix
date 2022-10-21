{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, writeTextFile
, setuptools
, analytics-python
, aiohttp
, fastapi
, ffmpy
, markdown-it-py
, linkify-it-py
, mdit-py-plugins
, matplotlib
, numpy
, orjson
, pandas
, paramiko
, pillow
, pycryptodome
, python-multipart
, pydub
, requests
, uvicorn
, jinja2
, fsspec
, httpx
, pydantic
, typing-extensions
, pytest-asyncio
, mlflow
, huggingface-hub
, transformers
, wandb
, respx
, scikitimage
, shap
, ipython
, pytestCheckHook
, websockets
}:

buildPythonPackage rec {
  pname = "gradio";
  version = "3.3";
  disabled = pythonOlder "3.7";

  # We use the Pypi release, as it provides prebuild webui assets,
  # and its releases are also more frequent than github tags
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mJojLaqTM5C6ZI+FTe/1J6yV8+GccgpwlgIMUQtJsC8=";
  };

  propagatedBuildInputs = [
    analytics-python
    aiohttp
    fastapi
    ffmpy
    matplotlib
    numpy
    orjson
    pandas
    paramiko
    pillow
    pycryptodome
    python-multipart
    pydub
    requests
    uvicorn
    jinja2
    fsspec
    httpx
    pydantic
    websockets
    markdown-it-py
  ] ++ markdown-it-py.optional-dependencies.plugins
    ++ markdown-it-py.optional-dependencies.linkify;

  postPatch = ''
    # Unpin h11, as its version was only pinned to aid dependency resolution.
    # Basically a revert of https://github.com/gradio-app/gradio/pull/1680
    substituteInPlace requirements.txt \
      --replace "h11<0.13,>=0.11" ""
  '';

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Python library for easily interacting with trained machine learning models";
  };
}