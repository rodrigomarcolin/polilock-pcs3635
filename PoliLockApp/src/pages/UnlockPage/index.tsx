import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
  IonButton,
} from "@ionic/react";
import { SubmitHandler, FieldValues } from "react-hook-form";
import PasswordForm from "../../components/PasswordForm";
import { lockOpen } from "ionicons/icons";

import { useRef } from "react";

const UnlockPage: React.FC = () => {
  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    console.log("testando submit");
    console.log(data);
  };

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Destrancar Armário</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent className={"ion-padding ion-margin"} fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Destrancar Armário</IonTitle>
          </IonToolbar>
        </IonHeader>

        <IonButton id="open-custom-dialog" expand="block">
          Open Custom Dialog
        </IonButton>

        <PasswordForm
          onSubmit={onSubmit}
          submitBtnText="Destrancar"
          btnIcon={lockOpen}
        />
      </IonContent>
    </IonPage>
  );
};

export default UnlockPage;
