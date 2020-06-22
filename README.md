# creed-robot

This repository is related to a prototype of smart robot cell for managing pharmaceutical depots. The description of the prototype and overview is under evaluation in scientific journals.

## Repository structure
The repository is structured as follows:
* barcode reader: code of the component interfacing a cognex barcode reader;
* robot: code running on a Kawaraki industrial robot series D;
* cognex-app: code of the componenent interfacing a cognex vision system for 3D object detection;
* sql: schema and population sample for the database component (Postgresql)
* python: code of the main application and supervision modules, orchestrating all the components.