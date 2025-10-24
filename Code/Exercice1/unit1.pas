unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql56conn, sqldb, db, Forms, Controls, Graphics, Dialogs,
  DBGrids, DBCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BTConnect: TButton;
    BTOut: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    MySQL56Connection1: TMySQL56Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BTConnectClick(Sender: TObject);
    procedure BTOutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BTConnectClick(Sender: TObject);
begin
  if  Form1.MySQL56Connection1.Connected = false then
    begin
       Form1.MySQL56Connection1.Connected := true;
       Form1.SQLQuery1.active := true;
       Form1.Label1.Caption :='Connecté';
       Form1.BTConnect.Caption :='Déconnexion';
    end
  else
    begin
       Form1.MySQL56Connection1.Connected := false;
       Form1.SQLQuery1.active := false;
       Form1.Label1.Caption :='Hors Connection';
       Form1.BTConnect.Caption :='Connexion';
    end
end;

procedure TForm1.BTOutClick(Sender: TObject);
begin
   Form1.MySQL56Connection1.Connected := false;
   Form1.Visible := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    Form1.MySQL56Connection1.Connected := false;
end;



end.

