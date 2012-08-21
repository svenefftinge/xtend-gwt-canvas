/*
 * Copyright 2011 Google Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License") you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.gwt.gwtcanvasdemo.client

import com.google.gwt.canvas.dom.client.Context2d
import com.google.gwt.dom.client.ImageElement

class Logo extends SpringObject {
  public ImageElement image
  public double rot

  new(ImageElement image) {
    super(new Vector(0,0))
    this.image = image
    this.rot = 0
  }
  
  def void draw(Context2d context) {
    context.save()
    context.translate(this.pos.x, this.pos.y)
    context.rotate(rot)
    context.drawImage(image, 0, 0)
    context.restore()
  }
}