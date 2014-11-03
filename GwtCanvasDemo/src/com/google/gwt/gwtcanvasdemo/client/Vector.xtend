/*
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

import org.eclipse.xtend.lib.annotations.Data

@Data class Vector {
  double x
  double y
  
  def static ->(double x, double y) {
  	new Vector(x,y)
  }
  
  def withX(double x) {
  	new Vector(x,y)
  }
  
  def withY(double y) {
  	new Vector(x,y)
  }
  
  def Vector +(Vector v) {
    new Vector(x+v.x, y+v.y)
  }
  
  def Vector -(Vector v) {
    new Vector(x-v.x, y-v.y)
  }
  
  def Vector *(Vector v) {
    new Vector(x*v.x, y*v.y)
  }
  
  def Vector *(double v) {
    new Vector(x*v, y*v)
  }
  
  def double mag() {
    if (x == 0 && y == 0) {
      return 0
    } else {
      return Math.sqrt(x * x + y * y)
    }
  }
  
  def double magSquared() {
    return x * x + y * y
  }
  
  override toString() {
  	return '('+x+' -> '+'y'+')'
  }
}