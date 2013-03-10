Magpie
============

How to use
------------
1. Install cabal-dev

2. Prepare executable 

    ```shell
    $ cabal-dev install --only-dependencies  
    $ cabal-dev install  
    ```

3. To setup DB, make db directory & run migrate.sh & dataPrepation.sh 

    ```shell
    $ mkdir db  
    $ chmod +x migrate.sh  
    $ ./migrate.sh  
    ```
  
4. Run executable

    ```shell
    $ ./dist/build/magpie/magpie  
    ```

5. Access http://localhost:3000
