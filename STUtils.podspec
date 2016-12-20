Pod::Spec.new do |s|
  s.name         = "STUtils"
  s.version      = "0.0.1"
  s.summary      = "A collection of useful Objective-C code from Buzz Andersen."
  s.homepage     = "https://github.com/acf/STUtils"

  s.license      = {
    :type => 'MIT',
    :text => <<-LICENSE

      Copyright 2012 System of Touch. All rights reserved.
    
      Permission is hereby granted, free of charge, to any person
      obtaining a copy of this software and associated documentation
      files (the "Software"), to deal in the Software without
      restriction, including without limitation the rights to use,
      copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the
      Software is furnished to do so, subject to the following
      conditions:
    
      The above copyright notice and this permission notice shall be
      included in all copies or substantial portions of the Software.
    
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
      OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
      OTHER DEALINGS IN THE SOFTWARE.

    LICENSE
  }
  s.author       = { "Buzz Andersen" => "buzz@scifihifi.com" }
  s.source       = { :git => "https://github.com/ldandersen/STUtils.git", :tag => '0.0.1' }

  osx_folders = ['Additions','Misc','Security','Stubs']
  ios_folders = ['Additions','Misc','Security','Stubs', 'iOS']

  s.ios.source_files = [ios_folders.map{|folder| "#{folder}/**/*.{h,m}"},'./STUtils.h'].flatten
  s.ios.public_header_files = [ios_folders.map{|folder| "#{folder}/**/*.h"},'./STUtils.h'].flatten
  s.ios.resources = "Resources/**/*.strings"
  s.ios.frameworks = ['Security','CoreLocation']

  s.osx.source_files = [osx_folders.map{|folder| "#{folder}/**/*.{h,m}"},'./STUtils.h'].flatten
  s.osx.public_header_files = [osx_folders.map{|folder| "#{folder}/**/*.h"},'./STUtils.h'].flatten
  s.osx.resources = "Resources/**/*.strings"
  s.osx.frameworks = ['Security']
end
