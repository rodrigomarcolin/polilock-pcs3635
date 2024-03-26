import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
} from "@ionic/react";
import { SubmitHandler, FieldValues } from "react-hook-form";
import PasswordForm from "../../components/PasswordForm";
import { create } from "ionicons/icons";

const ManagePage: React.FC = () => {
  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    console.log("testando submit");
    console.log(data);
  };

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Gerenciar Armário</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent className={"ion-padding ion-margin"} fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Gerenciar Armário</IonTitle>
          </IonToolbar>
        </IonHeader>

        <PasswordForm
          onSubmit={onSubmit}
          submitBtnText="Mudar Senha"
          btnIcon={create}
        />
      </IonContent>
    </IonPage>
  );
};

export default ManagePage;
