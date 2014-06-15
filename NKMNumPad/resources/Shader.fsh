//
//  Shader.fsh
//  GLTest
//
//  Created by hajime-nakamura on 6/13/14.
//  Copyright (c) 2014 hajime-nakamura. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
