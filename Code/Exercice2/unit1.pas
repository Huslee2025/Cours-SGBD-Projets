unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql56conn, sqldb, db, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBGrids, DBCtrls;

type

  { TFormMain }

  TFormMain = class(TForm)
    BtnConnect: TButton;
    BtnAjout: TButton;
    BtnSuppression: TButton;
    BtnSelect: TButton;
    BtnInsert: TButton;
    BtnDelete: TButton;
    BtnUpdate: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    EdNumero: TEdit;
    EdNom: TEdit;
    EdPrenom: TEdit;
    EdNationalite: TEdit;
    EdDateNaissance: TEdit;
    LblNumero: TLabel;
    LblNom: TLabel;
    LblPrenom: TLabel;
    LblNationalite: TLabel;
    LblDateNaissance: TLabel;
    LblStatus: TLabel;
    EdSelect: TMemo;
    EdInsert: TMemo;
    EdDelete: TMemo;
    EdUpdate: TMemo;
    MySQL56Connection1: TMySQL56Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BtnAjoutClick(Sender: TObject);
    procedure BtnConnectClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnInsertClick(Sender: TObject);
    procedure BtnSelectClick(Sender: TObject);
    procedure BtnSuppressionClick(Sender: TObject);
    procedure BtnUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FormMain: TFormMain;
  LastSelectSQL: string;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.BtnConnectClick(Sender: TObject);
begin
  try
    if not MySQL56Connection1.Connected then
    begin
      MySQL56Connection1.Connected := True;
      SQLTransaction1.Active := True;

      // Lister les tables
      SQLQuery1.Close;
      SQLQuery1.SQL.Text := 'SHOW TABLES';
      SQLQuery1.Open;

      LblStatus.Caption := 'Connecté';
      BtnConnect.Caption := 'Disconnect';
    end
    else
    begin
      SQLQuery1.Close;
      SQLTransaction1.Active := False;
      MySQL56Connection1.Connected := False;

      LblStatus.Caption := 'Non connecté';
      BtnConnect.Caption := 'Connect';
    end;
  except
    on E: Exception do
    begin
      LblStatus.Caption := 'Erreur';
      ShowMessage('Connexion échouée : ' + E.Message);
    end;
  end;
end;

procedure TFormMain.BtnAjoutClick(Sender: TObject);
begin
  if not MySQL56Connection1.Connected then
  begin
    ShowMessage('Veuillez d''abord vous connecter à la base de données.');
    Exit;
  end;

  try
    SQLQuery1.Close;
    SQLQuery1.SQL.Text :=
      'INSERT INTO auteurs (`nom`, `prénom`, `nationalité`, `année_naiss`) ' +
      'VALUES (:nom, :prenom, :nationalite, :annee_naiss)';

    SQLQuery1.Params.ParamByName('nom').AsString := EdNom.Text;
    SQLQuery1.Params.ParamByName('prenom').AsString := EdPrenom.Text;
    SQLQuery1.Params.ParamByName('nationalite').AsString := EdNationalite.Text;
    SQLQuery1.Params.ParamByName('annee_naiss').AsString := EdDateNaissance.Text;

    SQLQuery1.ExecSQL;
    MySQL56Connection1.Transaction.Commit;

    ShowMessage('Auteur ajouté avec succès.');

    // Recharge la dernière requête affichée (si c’était "SELECT * FROM auteurs")
    if Trim(LastSelectSQL) <> '' then
    begin
      SQLQuery1.Close;
      SQLQuery1.SQL.Text := LastSelectSQL;
      SQLQuery1.Open;
    end;

  except
    on E: Exception do
      ShowMessage('Erreur lors de l''ajout : ' + E.Message);
  end;
end;

procedure TFormMain.BtnDeleteClick(Sender: TObject);
begin
  if not MySQL56Connection1.Connected then
  begin
    ShowMessage('Veuillez d''abord vous connecter à la base de données.');
    Exit;
  end;

  if Trim(EdDelete.Text) = '' then
  begin
    ShowMessage('Veuillez entrer une requête de suppression SQL.');
    Exit;
  end;

  try
    SQLQuery1.Close;
    SQLQuery1.SQL.Text := EdDelete.Text;
    SQLQuery1.ExecSQL;
    MySQL56Connection1.Transaction.Commit;

    ShowMessage('Suppression effectuée avec succès.');

    // Recharge la dernière requête SELECT si elle existe
    if Trim(LastSelectSQL) <> '' then
    begin
      SQLQuery1.Close;
      SQLQuery1.SQL.Text := LastSelectSQL;
      SQLQuery1.Open;
    end;

  except
    on E: Exception do
      ShowMessage('Erreur lors de la suppression : ' + E.Message);
  end;
end;

procedure TFormMain.BtnInsertClick(Sender: TObject);
begin
  if not MySQL56Connection1.Connected then
  begin
    ShowMessage('Veuillez d''abord vous connecter à la base de données.');
    Exit;
  end;

  if Trim(EdInsert.Text) = '' then
  begin
    ShowMessage('Veuillez entrer une requête d''insertion SQL.');
    Exit;
  end;

  try
    SQLQuery1.Close;
    SQLQuery1.SQL.Text := EdInsert.Text;
    SQLQuery1.ExecSQL;   // Exécute la requête (pas de retour de données)
    MySQL56Connection1.Transaction.Commit;  // Valide la modification
    ShowMessage('Insertion effectuée avec succès.');

    // Recharge la dernière requête de sélection si elle existe
    if Trim(LastSelectSQL) <> '' then
    begin
      SQLQuery1.Close;
      SQLQuery1.SQL.Text := LastSelectSQL;
      SQLQuery1.Open;
    end;

  except
    on E: Exception do
      ShowMessage('Erreur lors de l''insertion : ' + E.Message);
  end;
end;

procedure TFormMain.BtnSelectClick(Sender: TObject);
begin
  // Vérifie si la connexion est active
  if not MySQL56Connection1.Connected then
  begin
    ShowMessage('Veuillez d''abord vous connecter à la base de données.');
    Exit;
  end;

  // Vérifie si une requête est entrée
  if Trim(EdSelect.Text) = '' then
  begin
    ShowMessage('Veuillez entrer une requête SQL dans le champ prévu.');
    Exit;
  end;

  try
    // Ferme la requête si déjà ouverte
    SQLQuery1.Close;

    // Applique la nouvelle requête entrée
    SQLQuery1.SQL.Text := EdSelect.Text;

    // Ouvre la requête et affiche les résultats
    SQLQuery1.Open;

    // Met à jour la grille avec les nouveaux résultats
    DBGrid1.DataSource := DataSource1;
    DataSource1.DataSet := SQLQuery1;

    // Sauvegarde la requête de sélection
    LastSelectSQL := EdSelect.Text;

  except
    on E: Exception do
      ShowMessage('Erreur lors de l''exécution : ' + E.Message);
  end;
end;

procedure TFormMain.BtnSuppressionClick(Sender: TObject);
begin
  if not MySQL56Connection1.Connected then
  begin
    ShowMessage('Veuillez d''abord vous connecter à la base de données.');
    Exit;
  end;

  if Trim(EdNumero.Text) = '' then
  begin
    ShowMessage('Veuillez entrer le numéro (auteur_id) à supprimer.');
    Exit;
  end;

  try
    SQLQuery1.Close;
    SQLQuery1.SQL.Text := 'DELETE FROM auteurs WHERE auteur_id = :id';
    SQLQuery1.Params.ParamByName('id').AsInteger := StrToInt(EdNumero.Text);
    SQLQuery1.ExecSQL;
    MySQL56Connection1.Transaction.Commit;

    ShowMessage('Auteur supprimé avec succès.');

    // Recharge le dernier SELECT (souvent "SELECT * FROM auteurs")
    if Trim(LastSelectSQL) <> '' then
    begin
      SQLQuery1.Close;
      SQLQuery1.SQL.Text := LastSelectSQL;
      SQLQuery1.Open;
    end;

  except
    on E: Exception do
    begin
      // Vérifie si c'est une erreur d'intégrité référentielle
      if Pos('foreign key constraint fails', LowerCase(E.Message)) > 0 then
        ShowMessage('Impossible de supprimer cet auteur car il est encore lié à un ou plusieurs livres.')
      else
        ShowMessage('Erreur lors de la suppression : ' + E.Message);

      // Ici, on relance juste la requête SELECT pour recharger la vue existante
      if Trim(LastSelectSQL) <> '' then
      begin
        SQLQuery1.Close;
        SQLQuery1.SQL.Text := LastSelectSQL;
        SQLQuery1.Open;
        end;
    end;
  end;
end;

procedure TFormMain.BtnUpdateClick(Sender: TObject);
begin
  if not MySQL56Connection1.Connected then
  begin
    ShowMessage('Veuillez d''abord vous connecter à la base de données.');
    Exit;
  end;

  if Trim(EdUpdate.Text) = '' then
  begin
    ShowMessage('Veuillez entrer une requête de modification SQL.');
    Exit;
  end;

  try
    SQLQuery1.Close;
    SQLQuery1.SQL.Text := EdUpdate.Text;
    SQLQuery1.ExecSQL;
    MySQL56Connection1.Transaction.Commit;

    ShowMessage('Modification effectuée avec succès.');

    // Recharge la dernière requête SELECT si elle existe
    if Trim(LastSelectSQL) <> '' then
    begin
      SQLQuery1.Close;
      SQLQuery1.SQL.Text := LastSelectSQL;
      SQLQuery1.Open;
    end;

  except
    on E: Exception do
      ShowMessage('Erreur lors de la modification : ' + E.Message);
  end;
end;


procedure TFormMain.FormCreate(Sender: TObject);
begin

end;

end.

