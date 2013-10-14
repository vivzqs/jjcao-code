----------------------
EfPiSoft - Version 1.0                                                              
----------------------

by Marco Attene
                                                                    
Consiglio Nazionale delle Ricerche                                        
Istituto di Matematica Applicata e Tecnologie Informatiche                
Sezione di Genova                                                         
IMATI-GE / CNR                                                            
                                                                         
This program implements the "fitting primitives" algorithm
described in the following paper:

Marco Attene, Michela Spagnuolo and Bianca Falcidieno
“Hierarchical Mesh Segmentation based on Fitting Primitives”
The Visual Computer, 22(3): 181-193, 2006.

Refer to the original paper for details on the theory behind
the method. After you know the theory, using the software
becomes straightforward.

--------------------
System Requirements
--------------------


*** Windows binaries ***

I run it successfully on Win 2000 Pro, XP Home, XP Pro.
I never tried it on any other version of Windows.
If your system does not include a recent development
environment, you may need to download and install
Microsoft Visual C++ 2005 Redistributable Package (x86),
available for download at:
http://www.microsoft.com/downloads/details.aspx?familyid=32BC1BEE-A3F9-4C13-9C99-220B62A191EE


*** Linux binaries ***

I run it successfully on Fedora Core 3, 4 and 5.
You need to add EfPiSoft's "libs" directory to your 
LD_LIBRARY_PATH environment variable.
If your system complains that libstdc++.so.6 cannot be found,
then append 'libsc++' too to the list of LD_LIBRARY_PATH.


*** Source Code ***

To compile the source code you need to have:
SIM's Coin3D 2.* and SoQt 1.*
 - download at "http://www.coin3d.org"
Trolltech's Qt 4.*
 - download at "http://www.trolltech.com/products/qt"
IMATI's JMeshLib 1.*
 - download at "http://jmeshlib.sourceforge.net

If you compile using Visual Studio (on Windows) you may use the
vcproj included in the package.
Otherwise, you may use 'qmake' (both Windows and Linux).

NOTICE that both the vcproj and the *.pro files assume that the
following environment variables are set on your system:
JMESHLIB - Directory containing the JMeshLib includes and libs
COINDIR  - Directory containing Coin3D and SoQt includes and libs
QTDIR    - Directory containing the QT4 includes and libs


---------
Copyright
---------

EfPiSoft is

Copyright(C) 2006: IMATI-GE / CNR                                       
                                                                          
All rights reserved.                                                      
                                                                          
This program is free software; you can redistribute it and/or modify      
it under the terms of the GNU General Public License as published by      
the Free Software Foundation; either version 2 of the License, or         
(at your option) any later version.                                       
                                                                          
This program is distributed in the hope that it will be useful,           
but WITHOUT ANY WARRANTY; without even the implied warranty of            
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             
GNU General Public License (http://www.gnu.org/licenses/gpl.txt)          
for more details.                                                         
