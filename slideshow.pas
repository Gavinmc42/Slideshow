program slideshow;

{$mode objfpc}{$H+}


{$hints off}
{$notes off}

uses
  ProgramInit,
  RaspberryPi4,
  GlobalConfig,
  GlobalConst,
  GlobalTypes,
  Platform,
  Threads,
  SysUtils,
  Classes,
  Font,
  Default8x16,
  Console,
  GraphicsConsole,
  Services,

  FPimage,
  FPReadPNG,
  FPReadJPEG,
  FPReadBMP,
  FPReadTIFF,
  FPReadGIF,
  FPReadTGA,
  FPReadPCX,
  FPReadPSD,

  uCanvas,

  Logging,
  uLog,
  FrameBuffer,
  freetypeh,
  Ultibo
  { Add additional units here };

const
  BACK_COLOUR                    = $FF055A93;

var
  Console1 : TWindowHandle;
  ch : char;
  i : integer;
  BGnd : TCanvas;
  aCanvas : TCanvas;
  anImage0 : TFPCustomImage;
  anImage1 : TFPCustomImage;
  anImage2 : TFPCustomImage;
  anImage3 : TFPCustomImage;
  anImage4 : TFPCustomImage;
  DefFrameBuff : PFrameBufferDevice;
  Properties : TWindowProperties;
  LargeFont:THandle;

procedure WaitForSDDrive;
begin
  while not DirectoryExists ('C:\') do sleep (500);
end;


procedure ProgramStartup;
begin
 //Enable Console Autocreate
 FRAMEBUFFER_CONSOLE_AUTOCREATE:=True;

 //Remove Console Border etc
 FRAMEBUFFER_CONSOLE_DEFAULT_DESKTOPOFFSET:=0;
 CONSOLE_DEFAULT_BORDERWIDTH:=0;

 //Create the Console
 //ConsoleFramebufferDeviceAdd(FramebufferDeviceGetDefault);

 //Create a Window
 //ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_FULL,True);

 //Show banner
 //ConsoleWriteLn('Welcome to program XYZ');
end;

begin
  ProgramStartup;

  LargeFont:=FontFindByName('Default8x16');
  ConsoleFramebufferDeviceAdd(FramebufferDeviceGetDefault);

  Console1 := GraphicsWindowCreate (ConsoleDeviceGetDefault, CONSOLE_POSITION_FULL);
  GraphicsWindowSetBackcolor (Console1, BACK_COLOUR);
  GraphicsWindowClear (Console1);

  GraphicsWindowDrawBox(Console1, 200,200,100,200, COLOR_RED, 5);
  GraphicsWindowSetForecolor (Console1, COLOR_WHITE);
  GraphicsWindowDrawText(Console1, 'LOADING IMAGES', 210,240);


  DefFrameBuff := FramebufferDeviceGetDefault;
  aCanvas := TCanvas.Create;
  if GraphicsWindowGetProperties (Console1, @Properties) = ERROR_SUCCESS then
    begin
      aCanvas.Left := Properties.X1;
      aCanvas.Top := Properties.Y1;
      aCanvas.SetSize (Properties.X2 - Properties.X1, Properties.Y2 - Properties.Y1 , COLOR_FORMAT_ARGB32);
    end;
  aCanvas.Fill (BACK_COLOUR);

  anImage0 := TFPMemoryImage.Create (0, 0);
  anImage1 := TFPMemoryImage.Create (0, 0);
  anImage2 := TFPMemoryImage.Create (0, 0);
  anImage3 := TFPMemoryImage.Create (0, 0);
  anImage4 := TFPMemoryImage.Create (0, 0);

  WaitForSDDrive;

  aCanvas.Flush (DefFrameBuff);   // renamed draw to flush


  try
   anImage1.LoadFromFile ('1a.bmp');
  finally
  end;
  try
   anImage2.LoadFromFile ('2a.bmp');
  finally
  end;
  try
   anImage3.LoadFromFile ('3a.bmp');
  finally
  end;
  try
   anImage4.LoadFromFile ('4a.bmp');
  finally
  end;

  while true do
    begin
      aCanvas.DrawImage (anImage1, 0, 0, aCanvas.Width, aCanvas.Height);
      aCanvas.Flush (DefFrameBuff);
      //sleep (1000);

      aCanvas.DrawImage (anImage2, 0, 0, aCanvas.Width, aCanvas.Height);
      aCanvas.Flush (DefFrameBuff);
      //sleep (1000);

      aCanvas.DrawImage (anImage3, 0, 0, aCanvas.Width, aCanvas.Height);
      aCanvas.Flush (DefFrameBuff);
      //sleep (1000);

      aCanvas.DrawImage (anImage4, 0, 0, aCanvas.Width, aCanvas.Height);
      aCanvas.Flush (DefFrameBuff);
      //sleep (1000);
    end;
  ThreadHalt (0);
end.

